;;; all-your-base.el --- All Your Base (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(defun num-to-seq (n)
  (mapcar (lambda (x)
            (string-to-number (char-to-string x)))
          (string-to-list (number-to-string n))))

(defun seq-to-num (s)
  (string-to-number (mapconcat #'number-to-string s nil)))

(defun convert-to-base-ten (rev-list-digits in-base i result)
  (if (>= i (length rev-list-digits))
      (num-to-seq result)
    (convert-to-base-ten rev-list-digits
                         in-base
                         (+ i 1)
                         (+ result (* (elt rev-list-digits i) (expt in-base i))))))

(defun convert-from-base-ten (num out-base rem-list)
  (if (zerop num)
      rem-list
    (convert-from-base-ten (truncate num out-base)
                           out-base
                           (cons (mod num out-base) rem-list))))

(defun error-check-pass-p (list-digits in-base out-base)
  (cond
   ((<= in-base 1) nil)
   ((<= out-base 1) nil)
   ((and (not (null list-digits)) (< (seq-min list-digits) 0)) nil)
   ((and (not (null list-digits)) (>= (seq-max list-digits) in-base)) nil)
   (t t)))

(defun rebase (list-digits in-base out-base)
  (if (not (error-check-pass-p list-digits in-base out-base))
      (error "Invalid input")
    (cond
     ((seq-every-p #'zerop list-digits) '(0))
     ((= 10 in-base) (convert-from-base-ten (seq-to-num list-digits) out-base '()))
     ((= 10 out-base) (convert-to-base-ten (reverse list-digits) in-base 0 1))
     (t (let ((num-in-base-ten (convert-to-base-ten (reverse list-digits) in-base 0 0)))
          (convert-from-base-ten (seq-to-num num-in-base-ten) out-base '()))))))

(provide 'all-your-base)
;;; all-your-base.el ends here
