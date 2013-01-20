#lang racket

(require math/array)

(require "wav-encode.rkt") ;; TODO does not accept arrays directly

;; TODO try to get deforestation for arrays. does that require
;;   non-strict arrays? lazy arrays?

(define fs 44100)
(define bits-per-sample 16)

(define (freq->sample-period freq)
  (round (/ fs freq)))

(define (seconds->samples s)
  (* s fs))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Oscillators

;; array functions receive a vector of indices
(define-syntax-rule (array-lambda (i) body ...)
  (lambda (i*) (let ([i (vector-ref i* 0)]) body ...)))

(define (sine-wave freq)
  (define f (/ (* freq 2 pi) fs))
  (array-lambda (x) (sin (* f x))))

(define (square-wave freq)
  (define sample-period (freq->sample-period freq))
  (define sample-period/2 (quotient sample-period 2))
  (array-lambda (x)
    ;; 1 for the first half of the cycle, -1 for the other half
    (define x* (modulo x sample-period))
    (if (> x* sample-period/2) -1.0 1.0)))


(define ((make-sawtooth-wave coeff) freq)
  (define sample-period (freq->sample-period freq))
  (define sample-period/2 (quotient sample-period 2))
  (array-lambda (x)
    ;; gradually goes from -1 to 1 over the whole cycle
    (define x* (modulo x sample-period))
    (* coeff (- (/ x* sample-period/2) 1.0))))
(define sawtooth-wave         (make-sawtooth-wave 1.0))
(define inverse-sawtooth-wave (make-sawtooth-wave -1.0))

(define (triangle-wave freq)
  (define sample-period (freq->sample-period freq))
  (define sample-period/2 (quotient sample-period 2))
  (define sample-period/4 (quotient sample-period 4))
  (array-lambda (x)
    ;; go from 1 to -1 for the first half of the cycle, then back up
    (define x* (modulo x sample-period))
    (if (> x* sample-period/2)
        (- (/ x* sample-period/4)    3.0)
        (+ (/ x* sample-period/4 -1) 1.0))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; assumes array of floats in [-1.0,1.0]
;; assumes gain in [0,1], which determines how loud the output is
(define (signal->integer-sequence signal #:gain [gain 1])
  (for/vector #:length (array-size signal)
              ([sample (in-array signal)])
    (max 0 (min (sub1 (expt 2 bits-per-sample)) ; clamp
                (inexact->exact
                 (floor (* (+ sample 1.0) ; center at 1, instead of 0
                           gain
                           (expt 2 (sub1 bits-per-sample)))))))))


(require plot)
(plot-new-window? #t)
;; shows 2 plots
;; - the original signal
;; - the "digitized" signal, with series for the bounds
;; press any key to dismiss
(define (plot-signal signal)
  (define n (array-size signal))
  (plot (points (for/list ([s (in-array signal)]
                           [i (in-naturals)])
                  (vector i s))))
  (plot (list (points (for/list ([s (in-vector
                                     (signal->integer-sequence signal))]
                                 [i (in-naturals)])
                        (vector i s)))
              (points (for/list ([i (in-range n)])
                        (vector i 0)))
              (points (for/list ([i (in-range n)])
                        (vector i (expt 2 bits-per-sample))))))
  (read-char))


(define (emit signal file)
  (with-output-to-file file #:exists 'replace
    (lambda () (write-wav (signal->integer-sequence signal #:gain 1/4)))))

(define sin-test (build-array `#(,(seconds->samples 2)) (sine-wave 440)))
(define square-test (build-array `#(,(seconds->samples 2)) (square-wave 440)))
(define sawtooth-test (build-array `#(,(seconds->samples 2)) (sawtooth-wave 440)))
(define inverse-sawtooth-test (build-array `#(,(seconds->samples 2)) (sawtooth-wave 440)))
(define triangle-test (build-array `#(,(seconds->samples 2)) (triangle-wave 440)))

(emit sin-test "sin.wav")
(emit square-test "square.wav")
(emit sawtooth-test "sawtooth.wav")
(emit inverse-sawtooth-test "inverse-sawtooth.wav")
(emit triangle-test "triangle.wav")

;; (plot-signal (build-array #(200) (sine-wave 440)))
;; (plot-signal (build-array #(2000) (square-wave 440)))
;; (plot-signal (build-array #(2000) (sawtooth-wave 440)))
;; (plot-signal (build-array #(2000) (inverse-sawtooth-wave 440)))
;; (plot-signal (build-array #(2000) (triangle-wave 440)))

