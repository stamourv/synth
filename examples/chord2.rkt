#lang racket

(require "../main.rkt")

(emit (sequence 1 (list (note 'C 3 1)
                        (chord 'C 3 1 'custom 0 4)
                        (chord 'C 3 1 'custom 0 4 7))
                90 sine-wave)
      "chord2.wav")
