#lang synth

#:output "major-scale.wav"
#:bpm 120

;; ascending major C scale
(sequence sine-wave #:times 2 [(scale C 3 1 major)])
