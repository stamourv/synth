#lang racket

(require "../main.rkt")

;; simple sine wave example, plays A3 G3 F3 twice at 60 BPM, with F3 twice as
;; long as the others

(emit (sequence 2 (list (note 'A 3 1) (note 'G 3 1) (note 'F 3 2))
                60 sine-wave)
      "sine.wav")
