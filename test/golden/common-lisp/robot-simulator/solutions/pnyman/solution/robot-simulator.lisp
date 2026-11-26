(defpackage :robot-simulator
  (:use :cl)
  (:export :+north+ :+east+ :+south+ :+west+ :execute-sequence
           :robot :robot-position :robot-bearing :make-robot))

(in-package :robot-simulator)

(defconstant +north+ 0)
(defconstant +east+ 1)
(defconstant +south+ 2)
(defconstant +west+ 3)

(defun make-robot (&key (position (cons 0 0)) (bearing +north+))
  (list :position position :bearing bearing))

(defun robot-bearing (robot)
  (getf robot :bearing))

(defun robot-position (robot)
  (getf robot :position))

(defun execute-sequence (robot sequence)
  (loop for s across sequence
        do (case s
             (#\R (setf (getf robot :bearing)
                        (mod (1+ (robot-bearing robot)) 4)))
             (#\L (setf (getf robot :bearing)
                        (mod (1- (robot-bearing robot)) 4)))
             (#\A (destructuring-bind (x . y) (robot-position robot)
                    (setf (getf robot :position)
                          (case (robot-bearing robot)
                            (0 (cons x (1+ y)))
                            (1 (cons (1+ x) y))
                            (2 (cons x (1- y)))
                            (3 (cons (1- x) y)))))))))
