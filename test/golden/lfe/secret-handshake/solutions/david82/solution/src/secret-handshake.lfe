(defmodule secret-handshake
  (export (commands 1)))

;; True if the bit `mask` is set in `n`
(defun bit-set? (n mask)
  (/= 0 (band n mask)))

(defun commands (n)
  (let* ((v (band n 31))      ; only keep the rightmost 5 bits
         (pairs '((1 "wink")
                  (2 "double blink")
                  (4 "close your eyes")
                  (8 "jump")))
         ;; Build actions from LSB -> MSB (1,2,4,8)
         (actions
           (lists:foldl
             (lambda (pair acc)
               (let (((list mask action) pair))
                 (if (bit-set? v mask)
                     (lists:append acc (list action))
                     acc)))
             '()
             pairs)))
    ;; If the 16 bit is set, reverse the order
    (if (bit-set? v 16)
        (lists:reverse actions)
        actions)))
    