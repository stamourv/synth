#lang synth

#:output "mixer.wav"
#:bpm 60

;; mixer example, where both tracks have the same weight
;; note: there's an implicit call to `mix' at the top-level
(mix (sequence sine-wave #:times 1 [(C 3 2) (E 3 2)])
     (sequence sine-wave #:times 1 [(E 3) (G 3) (F 3) (A 3)]))
