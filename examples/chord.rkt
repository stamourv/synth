#lang synth

#:output "chord.wav"
#:bpm 90

;; I-IV-V chord progression, using the chord generator
(sequence
  sine-wave #:times 1
  [(chord C 3 2 major-arpeggio)
   (chord F 3 2 major-arpeggio)
   (chord G 3 2 major-arpeggio)])
