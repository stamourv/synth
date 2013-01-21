#lang racket

(require "../main.rkt")

;; another mixer example, the second track is 5 times louder than the first
(emit (mix (list (sequence 1 (list (note 'G 3 2) (note 'E 3 2))
                           60 sine-wave) 1)
           (list (sequence 1 (list (note 'A 4 1) (note 'F 4 1) '(#f . 1)
                                   (note 'A 3 1))
                           60 sine-wave) 5))
      "mixer2.wav")
