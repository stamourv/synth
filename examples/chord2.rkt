#lang synth

#:output "chord2.wav"
#:bpm 90

(sequence
  sine-wave #:times 1
  [(C 3)
   (chord C 3 1 custom 0 4)
   (chord C 3 1 custom 0 4 7)])
