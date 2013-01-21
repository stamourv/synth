#lang racket

(require "../main.rkt")

;; ascending minor harmonic E scale
(emit (sequence 1 (scale 'E 3 1 'minor-harmonic) 120 sine-wave)
      "minor-harmonic-scale.wav")
