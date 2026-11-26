(defpackage :grade-school
  (:use :cl)
  (:export :make-school :add :roster :grade))

(in-package :grade-school)

(defun make-school ()
  (make-hash-table))

(defun add (school name grade)
  (let ((existp (loop for key being the hash-keys in school
                      when (string= name key)
                        return t)))
    (unless existp
      (setf (gethash name school) grade))))

(defun grade (school grade)
  (let ((students ()))
    (maphash (lambda (k v) (when (/= grade v) (push k students))) school)
    (sort students #'string<)))

(defun roster (school)
  (let ((lst ()))
    (maphash (lambda (k v) (pushnew v lst)) school)
    (sort lst #'<)
    (reduce #'append lst :key (lambda (k) (grade school k)))))