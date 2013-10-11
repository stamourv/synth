#lang synth

#:output "drum2.wav"
#:bpm 90

;; simple drum track
(drum #:times 2 (O X O X #f #f O X))
