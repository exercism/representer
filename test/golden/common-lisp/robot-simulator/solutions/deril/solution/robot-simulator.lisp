(in-package #:cl-user)
(defpackage #:robot-simulator
  (:use #:common-lisp)
  (:export #:+north+ #:+east+ #:+south+ #:+west+ #:execute-sequence
           #:robot #:robot-position #:robot-bearing #:make-robot))

(in-package #:robot-simulator)

(defconstant +north+ 0)
(defconstant +east+ 1)
(defconstant +south+ 2)
(defconstant +west+ 3)

(defclass robot ()
  ((position :initarg :robot-position :accessor robot-position)
   (bearing :initarg :robot-bearing :accessor robot-bearing)))

(defmethod turn-right ((r robot))
  (setf (robot-bearing r) (mod (1+ (robot-bearing r)) 4)))

(defmethod turn-left ((r robot))
  (setf (robot-bearing r) (mod (1- (robot-bearing r)) 4)))

(defmethod advance ((r robot))
  (case (robot-bearing r)
    (#.+north+ (incf (cdr (robot-position r))))
    (#.+east+ (incf (car (robot-position r))))
    (#.+south+ (decf (cdr (robot-position r))))
    (#.+west+ (decf (car (robot-position r))))))

(defmethod execute-sequence ((r robot) sequence)
  (loop for command across sequence do
    (case command
      (#\R (turn-right r))
      (#\L (turn-left r))
      (#\A (advance r)))))

(defun make-robot (&key (position (cons 0 0)) (bearing +north+))
  (make-instance 'robot :robot-position position :robot-bearing bearing))

