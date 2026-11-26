(defpackage :robot-name
  (:use :cl)
  (:export :build-robot :robot-name :reset-name))

(in-package :robot-name)

(defparameter +alphabet+ "ABCDEFGHIJKLMNOPQRSTUVXYZ")
(defparameter +used-names+ ())

(defun random-char ()
  (char +alphabet+ (random 27)))

(defun random-digit ()
  (random 10))

(defun random-name ()
  (format nil "~A~A~A~A~A"
          (random-char)
          (random-char)
          (random-digit)
          (random-digit)
          (random-digit)))

(defun unique-name ()
  (let ((nm (loop with name = (random-name)
                  when (not (member name +used-names+)) return name)))
       (setf +used-names+ (cons nm +used-names+))
       nm))

(defun build-robot ()
  (list (cons 'name (unique-name))))

(defun robot-name (r)
  (cdr (assoc 'name r)))

(defun reset-name (r)
  (setf (cdr (assoc 'name r)) (unique-name)))
