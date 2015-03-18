#lang synth/typed

#:output "funky-town.wav"
#:bpm 380

(sequence
 sawtooth-wave #:bpm 380 #:times 2
 [(C 5) #f (C 5) #f (A# 4) #f (C 5) (#f 3) (G 4) (#f 3)
  (G 4) #f (C 5) #f (F 5) #f (E 5) #f (C 5) (#f 9)])

(drum #:bpm 380 #:times 8 (O #f #f #f X #f #f #f))
