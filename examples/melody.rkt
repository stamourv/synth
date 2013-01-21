#lang racket

(require "../main.rkt")

;; melody + chord background
(emit (mix (list (sequence 1 (list (chord 'C 3 3 'major-arpeggio)
                                   (chord 'D 3 3 'major-arpeggio))
                           60 sine-wave) 1)
           (list (sequence 1 (list (note 'C 4 1) (note 'D 4 1) (note 'E 4 1)
                                   (note 'G 4 1) (note 'E 4 1) (note 'C 4 1))
                           60 square-wave) 3))
      "melody.wav")
