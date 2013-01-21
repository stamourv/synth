#lang racket

(require "../main.rkt")

;; same example as sine.scm and harmonics.scm, but with a square wave
(emit (sequence 2 (list (note 'A 3 1) (note 'G 3 1) (note 'F 3 2))
                120 square-wave)
      "square.wav")
