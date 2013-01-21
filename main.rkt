#lang racket

;; TODO have this be a #lang

(require "synth.rkt" "sequencer.rkt" "mixer.rkt")
(provide (all-from-out "synth.rkt" "sequencer.rkt" "mixer.rkt"))
