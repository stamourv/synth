#lang typed/racket

(require "synth.rkt" "sequencer.rkt" "mixer.rkt" "drum.rkt")
(provide (except-out (all-from-out "synth.rkt"
                                   "sequencer.rkt"
                                   "mixer.rkt"
                                   "drum.rkt")
                     mix sequence drum)
         (rename-out [mix/export      mix]
                     [sequence/export sequence]
                     [drum/export     drum]
                     [#%module-begin/export #%module-begin])
         #;(except-out (all-from-out typed/racket) provide #%module-begin))

(require (for-syntax syntax/parse) racket/stxparam)

(define-syntax-parameter current-bpm (syntax-rules ()))

(begin-for-syntax
 (define-syntax-class mixand
   #:attributes (signal weight)
   (pattern [signal:expr (~datum #:weight) weight:expr])
   (pattern signal:expr #:with weight #'1))
 )

(define-syntax (mix/export stx)
  (syntax-parse stx
    [(_ sig:mixand ...)
     #'(mix (list sig.signal sig.weight) ...)]))

(begin-for-syntax
 (define-syntax-class sequend
   #:attributes (res)
   (pattern (~datum #f) ; break of 1 unit
            #:with res #''[(#f . 1)])
   (pattern [(~datum #f) len:expr]
            #:with res #'`[,(cons #f len)])
   (pattern ((~literal chord) root octave duration type notes* ...)
            ;; TODO this syntax is not as nice as the others
            #:with res #'`[,(chord 'root octave duration 'type notes* ...)])
   (pattern ((~literal scale) root octave duration type notes* ...)
            ;; TODO this syntax is not as nice as the others
            #:with res #'(scale 'root octave duration 'type notes* ...))
   (pattern [n:id octave:expr] ; note of 1 unit
            ;; TODO id is too permissive
            #:with res #'`[,(note 'n octave 1)])
   (pattern [n:id octave:expr len:expr]
            #:with res #'`[,(note 'n octave len)]))
 )

(define-syntax (sequence/export stx)
  (syntax-parse stx
    ;; TODO OoO keywords, support for repetitions
    [(_ function:expr (~datum #:bpm) bpm:expr (~datum #:times) times:expr
        [note:sequend ...])
     #'(sequence times (list note.res ...) bpm function)]))

(define-syntax (drum/export stx)
  (syntax-parse stx
    [(_ (~datum #:bpm) bpm:expr (~datum #:times) times:expr [notes ...])
     #'(drum times '(notes ...) bpm)]))

(module reader syntax/module-reader
  #:language 'synth)

(define-syntax (#%module-begin/export stx)
  (syntax-parse stx
    [(_ #:output output:expr #:bpm bpm:expr
        signal ...)
     #'(#%module-begin
        (syntax-parameterize
         ([current-bpm (syntax-rules () [(_) bpm])])
         (emit (mix/export signal ...) output)))]))
