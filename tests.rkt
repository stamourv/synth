#lang racket

(require math/array "synth.rkt")

(define sin-test (build-array `#(,(seconds->samples 2)) (sine-wave 440)))
(define square-test (build-array `#(,(seconds->samples 2)) (square-wave 440)))
(define sawtooth-test (build-array `#(,(seconds->samples 2)) (sawtooth-wave 440)))
(define inverse-sawtooth-test (build-array `#(,(seconds->samples 2)) (sawtooth-wave 440)))
(define triangle-test (build-array `#(,(seconds->samples 2)) (triangle-wave 440)))

(emit sin-test "sin.wav")
(emit square-test "square.wav")
(emit sawtooth-test "sawtooth.wav")
(emit inverse-sawtooth-test "inverse-sawtooth.wav")
(emit triangle-test "triangle.wav")

;; (plot-signal (build-array #(200) (sine-wave 440)))
;; (plot-signal (build-array #(2000) (square-wave 440)))
;; (plot-signal (build-array #(2000) (sawtooth-wave 440)))
;; (plot-signal (build-array #(2000) (inverse-sawtooth-wave 440)))
;; (plot-signal (build-array #(2000) (triangle-wave 440)))
