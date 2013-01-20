#lang racket

(require math/array "synth.rkt" "sequencer.rkt")

;; (define sin-test (build-array `#(,(seconds->samples 2)) (sine-wave 440)))
;; (define square-test (build-array `#(,(seconds->samples 2)) (square-wave 440)))
;; (define sawtooth-test (build-array `#(,(seconds->samples 2)) (sawtooth-wave 440)))
;; (define inverse-sawtooth-test (build-array `#(,(seconds->samples 2)) (sawtooth-wave 440)))
;; (define triangle-test (build-array `#(,(seconds->samples 2)) (triangle-wave 440)))

;; (emit sin-test "sin.wav")
;; (emit square-test "square.wav")
;; (emit sawtooth-test "sawtooth.wav")
;; (emit inverse-sawtooth-test "inverse-sawtooth.wav")
;; (emit triangle-test "triangle.wav")

;; (plot-signal (build-array #(200) (sine-wave 440)))
;; (plot-signal (build-array #(2000) (square-wave 440)))
;; (plot-signal (build-array #(2000) (sawtooth-wave 440)))
;; (plot-signal (build-array #(2000) (inverse-sawtooth-wave 440)))
;; (plot-signal (build-array #(2000) (triangle-wave 440)))


;; (emit (mix (list (sequence 3 (scale 'C 3 1 'major) 240 sine-wave)
;;                  0.5)
;;            (list (sequence 1 (scale 'C 4 1 'major-arpeggio) 120 sine-wave)
;;                  0.5))
;;       "scale.wav")

;; TODO have a better data entry method, esp. for pauses
;; (emit (sequence 3 (list (chord 'C 4 2 'major-arpeggio) (chord 'C 4 1 'minor-arpeggio) '(#f #f 2))
;;                 120 sine-wave)
;;       ;; TODO that is enough to take 1 minute (!) at 60bpm (with 'major and 'minor, not arpeggios)
;;       "chords.wav")

(emit (mix (list (sequence 2 (list (chord 'C 3 3 'major-arpeggio)
                                   (chord 'C 3 3 'minor-arpeggio))
                           120 sine-wave)
                 1)
           (list (sequence 2 (append (scale 'C 4 1 'major-arpeggio)
                                     (scale 'C 4 1 'minor-arpeggio))
                           120 sine-wave)
                 2))
      "arpeggio.wav")
;; TODO oops, OOM-killed after 3m22s (if I have the pattern pre-processing
;;   thing in `sequence'), otherwise takes ~30s, and not much memory
