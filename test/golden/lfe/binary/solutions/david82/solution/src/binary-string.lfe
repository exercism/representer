(defmodule binary-string
  (export (to-decimal 1)))

;; Public API
(defun to-decimal
  ;; Only operate on strings (lists of character codes in Erlang/LFE).
  ((s) (when (is_list s)) (to-decimal-acc s 0))
  ;; Any non-string input yields 0.
  ((_) 0))

;; Tail-recursive worker that folds left-to-right:
;; acc' = acc*2 + bit, where bit is 0 or 1.
(defun to-decimal-acc
  (('() acc) acc)
  (((cons h t) acc)
   (case h
     ;; Character code 48 = "0"
     (48 (to-decimal-acc t (* 2 acc)))
     ;; Character code 49 = "1"
     (49 (to-decimal-acc t (+ (* 2 acc) 1)))
     ;; Any invalid character -> 0 (invalid input handling)
     (_ 0))))
