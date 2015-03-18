#lang typed/racket/base

(require math/array)

(require "synth.rkt")

(provide drum Drum-Symbol Pattern)

(define-type Drum-Symbol (U 'O 'X #f))
(define-type Pattern (Listof Drum-Symbol))

(: random-sample (-> Float))
(define (random-sample) (- (* 2.0 (random)) 1.0))

;; Drum "samples" (Arrays of floats)
;; TODO compute those at compile-time
(: bass-drum (Array Float))
(define bass-drum
  (let ()
    ;; 0.05 seconds of noise whose value changes every 12 samples
    (: n-samples Integer)
    (define n-samples           (seconds->samples 0.05))
    (: n-different-samples Integer)
    (define n-different-samples (quotient n-samples 12))
    (: ds In-Indexes)
    (define ds (vector n-samples))
    (for/array: #:shape ds
               #:fill 0.0
               ([i (in-range n-different-samples)]
                [sample (in-producer random-sample (lambda _ #f))]
                #:when #t
                [j (in-range 12)]) : Float
       sample)))

(: snare (Array Float))
(define snare
  ;; 0.05 seconds of noise
  (let: ([indexes : In-Indexes
                  (vector (seconds->samples 0.05))]
         [arr-gen : (-> Indexes Flonum)
                  (lambda ([x : Indexes]) (random-sample))])
    (build-array indexes arr-gen)))

;; limited drum machine
(: drum (-> Natural Pattern Natural (Array Float)))
(define (drum n pattern tempo)
  (: samples-per-beat Natural)
  (define samples-per-beat (quotient (* fs 60) tempo))
  (: make-drum (-> (Array Float) Natural (Array Float)))
  (define (make-drum drum-sample samples-per-beat)
    (array-append*
     (list drum-sample
           (make-array (vector (- samples-per-beat
                                  (array-size drum-sample)))
                       0.0))))
  (: O (Array Float))
  (define O     (make-drum bass-drum samples-per-beat))
  (: X (Array Float))
  (define X     (make-drum snare     samples-per-beat))
  (: pause (Array Float))
  (define pause (make-array (vector samples-per-beat) 0.0))
  (array-append*
   (for*/list : (Listof (Array Float)) ([i : Integer (in-range n)]
                                        [beat : Drum-Symbol (in-list pattern)])
     (case beat
       [(X)  X]
       [(O)  O]
       [(#f) pause]))))
