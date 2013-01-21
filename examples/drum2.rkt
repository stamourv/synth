#lang racket

(require "../main.rkt")

;; simple drum track
(emit (drum 2 '(O X O X #f #f O X) 90)
      "drum2.wav")
