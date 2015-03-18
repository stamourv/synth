#lang typed/racket

(provide
  fs
  sawtooth-wave
  seconds->samples
  emit)

(require math/array)

(require "wav-encode.rkt") ;; TODO does not accept arrays directly

;; TODO try to get deforestation for arrays. does that require
;;   non-strict arrays? lazy arrays?
(array-strictness #f)
;; TODO this slows down a bit, it seems, but improves memory use


(: fs Natural)
(define fs 44100)
(: bits-per-sample Natural)
(define bits-per-sample 16)

;; Wow this is too much work
(: freq->sample-period (-> Float Integer))
(define (freq->sample-period freq)
  (: res Exact-Rational)
  (define res (inexact->exact (round (/ fs freq))))
  (if (index? res) res (error "not index")))

(: seconds->samples (-> Float Integer))
(define (seconds->samples s)
  (: res Exact-Rational)
  (define res (inexact->exact (round (* s fs))))
  (if (index? res) res (error "not index")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Oscillators

;; array functions receive a vector of indices
(define-syntax-rule (array-lambda (i) body ...)
  (lambda ([i* : Indexes])
    (let: ([i : Integer (vector-ref i* 0)]) body ...)))

(: make-sawtooth-wave (-> Float (-> Float (-> Indexes Float))))
(define ((make-sawtooth-wave coeff) freq)
  (: sample-period Integer)
  (define sample-period (freq->sample-period freq))
  (: sample-period/2 Integer)
  (define sample-period/2 (quotient sample-period 2))
  (array-lambda (x)
    ;; gradually goes from -1 to 1 over the whole cycle
    (: x* Float)
    (define x* (exact->inexact (modulo x sample-period)))
    (* coeff (- (/ x* sample-period/2) 1.0))))
(: sawtooth-wave (-> Float (-> Indexes Float)))
(define sawtooth-wave         (make-sawtooth-wave 1.0))

;; TODO make sure that all of these actually produce the right frequency
;;  (i.e. no off-by-an-octave errors)

;; TODO add weighted-harmonics, so we can approximate instruments
;;  and take example from old synth

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide emit); plot-signal)

;; assumes array of floats in [-1.0,1.0]
;; assumes gain in [0,1], which determines how loud the output is
(: signal->integer-sequence (-> (Array Float) [#:gain Float] (Vectorof Integer)))
(define (signal->integer-sequence signal #:gain [gain 1])
  (for/vector : (Vectorof Integer) #:length (array-size signal)
              ([sample : Float (in-array signal)])
    (max 0 (min (sub1 (expt 2 bits-per-sample)) ; clamp
                (exact-floor
                 (* gain
                    (* (+ sample 1.0) ; center at 1, instead of 0
                       (expt 2 (sub1 bits-per-sample)))))))))


(: emit (-> (Array Float) Path-String Void))
(define (emit signal file)
  (with-output-to-file file #:exists 'replace
    (lambda () (write-wav (signal->integer-sequence signal #:gain 0.3)))))

