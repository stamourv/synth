#lang racket

(require "../main.rkt")

;; I-IV-V chord progression, using the chord generator
(emit (sequence 1 (list (chord 'C 3 2 'major-arpeggio)
                        (chord 'F 3 2 'major-arpeggio)
                        (chord 'G 3 2 'major-arpeggio))
                90 sine-wave)
      "chord.wav")
