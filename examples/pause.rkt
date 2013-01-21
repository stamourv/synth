#lang racket

(require "../main.rkt")

;; sine wave example with a pause in the middle
(emit (sequence 4 (list (note 'C 3 1) '(#f . 1) (note 'E 3 1)) 120 sine-wave)
      "pause.wav")
