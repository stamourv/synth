#lang racket

(require math/array)

(require "wav-encode.rkt") ;; TODO does not accept arrays directly

;; TODO try to get deforestation for arrays. does that require
;;   non-strict arrays? lazy arrays?

(define fs 44100)
(define bits-per-sample 16)

(define (sine-wave freq)
  (let ([f (/ (* freq 2 pi) fs)])
    ;; array functions receive a vector of indices
    (match-lambda [(vector x) (sin (* f x))])))

(define (seconds->samples s)
  (* s fs))

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


(define sin-test (build-array `#(,(seconds->samples 2)) (sine-wave 440)))
(with-output-to-file "foo.wav" #:exists 'replace
  (lambda () (write-wav (signal->integer-sequence sin-test #:gain 1/4))))
;; (plot-signal (build-array #(200) (sine-wave 440)))
