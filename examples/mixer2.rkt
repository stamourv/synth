#lang synth

#:output "mixer2.wav"
#:bpm 60

;; another mixer example, the second track is 5 times louder than the first
;; note: there's an implicit call to `mix' at the top-level
(mix (sequence sine-wave #:times 1 [(G 3 2) (E 3 2)])
     [(sequence sine-wave #:times 1 [(A 4) (F 4) #f (A 3)])
      #:weight 5])
