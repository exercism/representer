(defpackage :robot-name
  (:use :cl)
  (:export :build-robot :robot-name :reset-name))

(in-package :robot-name)

(defvar *robots* (make-hash-table :test #'equal))

(defparameter *max-robots* (* 26 26 10 10 10 0.80)
  "The probability of name collisions is TOO DAMN HIGH!")

(defstruct (robot) name)

(defun make-random-robot-name ()
  (flet ((rand-char ()
           (code-char (+ 65 (random 26))))
         (rand-digit ()
           (code-char (+ 48 (random 10)))))
    (format nil "~c~c~c~c~c"
            (rand-char) (rand-char) (rand-digit) (rand-digit) (rand-digit))))

(defun unique-robot-name-p (name)
  (null (nth-value 1 (gethash name *robots*))))

(defun make-unique-random-robot-name ()
  (loop :for name := (make-random-robot-name)
        :until (unique-robot-name-p name)
        :finally (return name)))

(defun reset-name (robot)
  (remhash (robot-name robot) *robots*)
  (setf (robot-name robot) (make-unique-random-robot-name))
  (setf (gethash (robot-name robot) *robots*) robot))

(defun build-robot ()
  (when (> (hash-table-count *robots*) *max-robots*)
    (error (documentation '*max-robots* 'variable)))
  (reset-name (make-robot)))
