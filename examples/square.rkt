#lang synth

#:output "square.wav"
#:bpm 120

;; same example as sine.scm and harmonics.scm, but with a square wave
(sequence square-wave #:times 2 [(A 3) (G 3) (F 3 2)])
