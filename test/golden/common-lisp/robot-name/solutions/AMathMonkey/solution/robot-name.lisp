(defpackage :robot-name
  (:use :cl)
  (:export :build-robot :robot-name :reset-name))

(in-package :robot-name)

(defvar *existing-names* (make-hash-table :test #'equal))

(defun rand-letter ()
  (code-char (+ 65 (random #.(1+ (- 90 65))))))

(defun rand-digit-char ()
  (digit-char (random 10)))

(defun name-unique-p (name)
  (not (nth-value 1 (gethash name *existing-names*))))

(defun new-name ()
  (loop for new-name = 
     (coerce 
       (loop for i from 1 to 5
        if (<= 1 i 2) collect (rand-letter)
        else collect (rand-digit-char))
       'string)
   if (name-unique-p new-name) do (setf (gethash new-name *existing-names*) nil)
   and return new-name))

(defun build-robot ()
  (list (new-name)))

(defun robot-name (robot)
  (car robot))

(defun reset-name (robot)
  (rplaca robot (new-name))
  (remhash (car robot) *existing-names*))
