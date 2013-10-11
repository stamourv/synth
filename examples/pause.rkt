#lang synth

#:output "pause.wav"
#:bpm 120

;; sine wave example with a pause in the middle
(sequence sine-wave #:times 4 [(C 3) #f (E 3)])
