#lang synth

#:output "smoke-on-the-water.wav"
#:bpm 224

;; main riff from "Smoke on the Water", by Deep Purple
(sequence sawtooth-wave #:times 1
          [(chord D 3 1 custom 0 5) #f
           (chord D 3 1 custom 3 8) #f
           (chord D 3 2 custom 5 10) #f
           (chord D 3 1 custom 0 5) #f
           (chord D 3 1 custom 3 8) #f
           (chord D 3 1 custom 6 11)
           (chord D 3 2 custom 5 10) (#f 2)
           
           (chord D 3 1 custom 0 5) #f
           (chord D 3 1 custom 3 8) #f
           (chord D 3 2 custom 5 10) #f
           (chord D 3 1 custom 3 8) #f
           (chord D 3 5 custom 0 5)])
(drum #:times 2 (O #f X #f O #f X #f O #f X #f O O X X))
