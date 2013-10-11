#lang synth

#:output "custom-scale.wav"
#:bpm 120

;; custom "scale"
(sequence sine-wave #:times 2
          [(scale C 3 1 custom 0 4 0 3 0 7)])
