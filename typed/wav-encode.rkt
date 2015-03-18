#lang typed/racket/base

;; Simple WAVE encoder

;; Very helpful reference:
;; http://ccrma.stanford.edu/courses/422/projects/WaveFormat/

(provide write-wav)
(require racket/sequence)

;; A WAVE file has 3 parts:
;;  - the RIFF header: identifies the file as WAVE
;;  - fmt subchunk: describes format of the data subchunk
;;  - data subchunk

;; data : sequence of 32-bit unsigned integers
(: write-wav (->* ((Sequenceof Integer))
                  (#:num-channels (U 1 2)
                   #:sample-rate Natural
                   #:bits-per-sample Natural)
                  Void))
(define (write-wav data
                   #:num-channels    [num-channels    1] ; 1 = mono, 2 = stereo
                   #:sample-rate     [sample-rate     44100]
                   #:bits-per-sample [bits-per-sample 16])
  (: bytes-per-sample Integer)
  (define bytes-per-sample
    (let ([i (quotient bits-per-sample 8)])
      (unless (integer? i) (error "write-wav")) i))
  (: write-integer-bytes (->* (Integer) (Integer) Integer))
  (define (write-integer-bytes i [size 4])
    (write-bytes (integer->integer-bytes i size #f)))
  (: data-subchunk-size Integer)
  (define data-subchunk-size
    (let ([i (* (sequence-length data) num-channels (/ bits-per-sample 8))])
      (unless (integer? i) (error "write-wav")) i))

  ;; RIFF header
  (write-bytes #"RIFF")
  ;; 4 bytes: 4 + (8 + size of fmt subchunk) + (8 + size of data subchunk)
  (write-integer-bytes (+ 36 data-subchunk-size))
  (write-bytes #"WAVE")

  ;; fmt subchunk
  (write-bytes #"fmt ")
  ;; size of the rest of the subchunk: 16 for PCM
  (write-integer-bytes 16)
  ;; audio format: 1 = PCM
  (write-integer-bytes 1 2)
  (write-integer-bytes num-channels 2)
  (write-integer-bytes sample-rate)
  ;; byte rate
  (write-integer-bytes (* sample-rate num-channels bytes-per-sample))
  ;; block align
  (write-integer-bytes (* num-channels bytes-per-sample) 2)
  (write-integer-bytes bits-per-sample 2)

  ;; data subchunk
  (write-bytes #"data")
  (write-integer-bytes data-subchunk-size)
  (for ([sample data])
    (write-integer-bytes sample bytes-per-sample)))
