(defpackage :robot-simulator
  (:use :cl)
  (:export :+north+ :+east+ :+south+ :+west+ :execute-sequence
           :robot :robot-position :robot-bearing :make-robot))

(in-package :robot-simulator)

(defconstant +north+ '(0 . 1))
(defconstant +east+  '(1 . 0))
(defconstant +south+ '(0 . -1))
(defconstant +west+  '(-1 . 0))
(defconstant +compass+ (list +north+ +west+ +south+ +east+ +north+))

(defclass robot ()
  ((position :initarg :position
             :initform '(0 . 0))
   (bearing :initarg :bearing
            :initform +north+)))

(defun add (cons1 cons2)
  (cons (+ (car cons1) (car cons2))
        (+ (cdr cons1) (cdr cons2))))

(defmethod turn-left (robot)
  (let ((bearing (slot-value robot 'bearing)))
    (setf (slot-value robot 'bearing)
          (cadr (member bearing +compass+)))))
(defmethod turn-right (robot)
  (let ((bearing (slot-value robot 'bearing)))
    (setf (slot-value robot 'bearing)
          (cadr (member bearing (reverse +compass+))))))
(defmethod advance (robot)
  (setf (slot-value robot 'position)
    (add (slot-value robot 'position)
         (slot-value robot 'bearing)))
  (slot-value robot 'position))

(defmethod make-robot (&key ((:position pos)) ((:bearing bear)))
  (let ((robot (make-instance 'robot)))
    (when pos (setf (slot-value robot 'position) pos))
    (when bear (setf (slot-value robot 'bearing) bear))
    robot))

(defmethod robot-position (robot) (slot-value robot 'position))

(defmethod robot-bearing (robot) (slot-value robot 'bearing))

(defmethod execute-sequence (robot seq)
  (loop for c across seq do
        (case c
          (#\R (turn-right robot))
          (#\L (turn-left robot))
          (#\A (advance robot))))
  (slot-value robot 'position))