#lang racket

(require "../main.rkt")

;; mixer example, where both tracks have the same weight
(emit (mix (list (sequence 1 (list (note 'C 3 2) (note 'E 3 2))
                           60 sine-wave) 1)
           (list (sequence 1 (list (note 'E 3 1) (note 'G 3 1)
                                   (note 'F 3 1) (note 'A 3 1))
                           60 sine-wave) 1))
      "mixer.wav")
