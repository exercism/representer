(defmodule atbash-cipher
  (export (encode 1)
          (decode 1)))

;; -- Public API --------------------------------------------------------------

(defun encode (Str)
  (let* ((lowered   (lower Str))
         (mapped    (transform lowered))    ; letters -> atbash, digits kept, others dropped
         (grouped   (group5 mapped)))       ; insert spaces every 5 chars
    grouped))

(defun decode (Str)
  (let* ((lowered (lower Str))
         (mapped  (transform lowered)))     ; same transform; no grouping on decode
    mapped))

;; -- Helpers -----------------------------------------------------------------

;; ASCII-only lowercase to avoid OTP/version differences.
(defun lower (S)
  (lists:map
    (lambda (C)
      (if (andalso (>= C 65) (=< C 90))     ; 'A'..'Z'
          (+ C 32)                          ; -> 'a'..'z'
          C))
    S))

;; Keep digits, map letters with Atbash, drop everything else.
(defun transform (Cs)
  (lists:foldr
    (lambda (C Acc)
      (cond
        ((andalso (>= C 97) (=< C 122)) (cons (atbash C) Acc))  ; 'a'..'z'
        ((andalso (>= C 48) (=< C 57))  (cons C Acc))           ; '0'..'9'
        ('true Acc)))                                           ; drop punctuation/whitespace
    '()
    Cs))

;; For lowercase ASCII letters: 'a'..'z' -> 'z'..'a'
;; Uses the identity: mapped = ($a + $z) - C = 219 - C
(defun atbash (C)
  (- 219 C))

;; Insert a space before every 6th, 11th, 16th, ... character
(defun group5 (Cs)
  (group5 Cs 0 '()))

(defun group5
  (('() _ Acc) (lists:reverse Acc))
  (((cons C Rest) Count Acc)
    (if (andalso (> Count 0) (== (rem Count 5) 0))
        ;; add a space before starting a new group
        (group5 Rest (+ Count 1) (cons C (cons 33 Acc))) ; 32 = space
        (group5 Rest (+ Count 1) (cons C Acc)))))
