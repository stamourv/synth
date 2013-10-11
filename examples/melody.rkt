#lang synth

#:output "melody.wav"
#:bpm 60

;; melody + chord background
(mix (sequence sine-wave #:times 1
               [(chord C 3 3 major-arpeggio)
                (chord D 3 3 major-arpeggio)])
     [(sequence square-wave #:times 1
                [(C 4) (D 4) (E 4)
                 (G 4) (E 4) (C 4)])
      #:weight 3])
