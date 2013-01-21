#lang racket

(require "../main.rkt")

;; custom "scale"
(emit (sequence 2 (scale 'C 3 1 'custom 0 4 0 3 0 7) 120 sine-wave)
      "custom-scale.wav")
