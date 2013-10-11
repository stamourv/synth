#lang synth

#:output "sine.wav"
#:bpm 60

;; simple sine wave example, plays A3 G3 F3 twice at 60 BPM, with F3 twice as
;; long as the others
(sequence sine-wave #:times 2 [(A 3) (G 3) (F 3 2)])
