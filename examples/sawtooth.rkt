#lang racket

(require "../main.rkt")

;; same examples as sine.scm, harmonics.scm and square.scm, but with a
;; sawtooth wave
(emit (sequence 2 (list (note 'A 3 1) (note 'G 3 1) (note 'F 3 2))
                120 sawtooth-wave)
      "sawtooth.wav")
