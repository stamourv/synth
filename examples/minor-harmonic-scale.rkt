#lang synth

#:output "minor-harmonic-scale.wav"
#:bpm 120

;; ascending minor harmonic E scale
(sequence sine-wave #:times 1 [(scale E 3 1 minor-harmonic)])
