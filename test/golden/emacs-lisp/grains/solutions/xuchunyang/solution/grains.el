;;; grains.el --- Grains exercise (exercism)

;;; Commentary:

;;; Code:

(require 'seq)

(defun square (n)
  (if (fboundp 'bignump)
      ;; Emacs 27
      (expt 2 (1- n))
    ;; In Emacs 26.1, (expt 2 63) returns 0
    ;; and note that (= 1 1.0) returns t
    (expt 2.0 (1- n))))

;; (defun total ()
;;   (apply #'+
;;          (seq-reduce (lambda (acc elt)
;;                        (pcase acc
;;                          (`(,x . ,_) (cons (* 2 x) acc))
;;                          (t (cons 1 acc))))
;;                      (number-sequence 1 64)
;;                      (list))))

;; https://exercism.io/tracks/elisp/exercises/grains/solutions/6a9b62e3fc6c4a95a9f01e0bfd9b0d90
(defun total ()
  (1- (square (1+ 64))))

(provide 'grains)
;;; grains.el ends here
