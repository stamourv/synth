#lang racket

(require "../main.rkt")

;; simple drum track
(emit (drum 8 '(O X #f) 90)
      "drum.wav")
