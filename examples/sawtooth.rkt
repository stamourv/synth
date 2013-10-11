#lang synth

#:output "sawtooth.wav"
#:bpm 120

;; same examples as sine.scm, harmonics.scm and square.scm, but with a
;; sawtooth wave
(sequence sawtooth-wave #:times 2 [(A 3) (G 3) (F 3 2)])
