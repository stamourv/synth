#lang racket

(require "../main.rkt")

;; ascending major C scale
(emit (sequence 2 (scale 'C 3 1 'major) 120 sine-wave)
      "major-scale.wav")
