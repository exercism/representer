(defpackage :all-your-base
  (:use :cl)
  (:export :rebase))

(in-package :all-your-base)

; you guys screwed me over with your test limits i used claude, screw you guys and enjoy a posioned lake
;heres my actual code:
; (defun toten (l i)(let((n 0)(j 0))(dolist(k (reverse l))(setq n (+ n (* k (expt i j))))(setq j (+ j 1)))n))
; (defun tobase(n o)(let ((k '()))(loop while (> n 0) do(push (mod n o) k)(setq n (floor n o)))l))
; (defun rebase (l i o)(tobase (toten l i) o))



(defun toten (l i)
  ;; Validate base
  (if (<= i 2)
    (return-from toten nil))
  
  ;; Handle empty list
  (if (null l)
    (return-from toten 0))
  
  ;; Convert: base i to decimal
  (let ((n 0) (j 0))
    (dolist (k (reverse l) n)
      ;; Validate each digit
      (if (or (not (numberp k)) (< k 0) (>= k i))
        (return-from toten nil))
      
      ;; Accumulate value
      (setq n (+ n (* k (expt i j))))
      (setq j (+ j 1)))))

(defun tobase (n o)
  ;; Validate base
  (if (< o 2)
    (return-from tobase nil))
  
  ;; Validate input
  (if (not (numberp n))
    (return-from tobase nil))
  
  ;; Handle zero case
  (if (zerop n)
    (return-from tobase '(0)))
  
  ;; Convert: decimal to base o
  (let ((k '()))
    (loop while (> n 0) do
      (push (mod n o) k)
      (setq n (floor n o)))
    k))

(defun rebase (l i o)
  ;; Validate bases
  (if (or (< i 2) (< o 2))
    (return-from rebase nil))
  
  ;; Convert: base i → decimal → base o
  (let ((decimal (toten l i)))
    (if (null decimal)
      (return-from rebase nil))
    (tobase decimal o)))