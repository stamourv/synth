#lang typed/racket

(require math/array)

(provide mix)

;; Weighted sum of signals, receives a list of lists (signal weight).
;; Shorter signals are repeated to match the length of the longest.
;; Normalizes output to be within [-1,1].
;; TODO use structs for these things
(define-type Weighted-Signal (List (Array Float) Real))
(: mix : Weighted-Signal * -> (Array Float))
(define (mix . ss)
  (define signals (map (lambda: ([x : Weighted-Signal]) (car x)) ss))
  (define weights (map (lambda: ([x : Weighted-Signal])
                         (real->double-flonum (cadr x))) ss))
  (define downscale-ratio (/ 1.0 (apply + weights)))
  (: scale-signal (Float -> (Float -> Float)))
  (define ((scale-signal w) x) (* x w downscale-ratio))
  (parameterize ([array-broadcasting 'permissive]) ; repeat short signals
    (for/fold ([res (array-map (scale-signal (first weights))
                               (first signals))])
        ([s (in-list (rest signals))]
         [w (in-list (rest weights))])
      (define scale (scale-signal w))
      (array-map (lambda: ([acc : Float] [new : Float]) (+ acc (scale new)))
                 res s))))

;; TODO see if moving this here is enough of an improvement
;;  -> meh, ~25s -> ~15s (not counting typechecking time)
;;  -> for future measurements of the type boundary, just use no-check
;; TODO maybe declutter unsafe ops in generators and elsewhere, if they don't
;;  affect performance much
