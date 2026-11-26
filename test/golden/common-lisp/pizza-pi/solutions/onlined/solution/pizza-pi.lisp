(defpackage :pizza-pi
  (:use :cl)
  (:export :dough-calculator :pizzas-per-cube
           :size-from-sauce :fair-share-p))

(in-package :pizza-pi)

(defun dough-calculator (pizzas diameter) (values (round (* pizzas (+ 200 (/ (* 45 pi diameter) 20))))))

(defun size-from-sauce (sauce) (sqrt (/ (* 40 sauce) 3 pi)))

(defun pizzas-per-cube (cube-size diameter) (values (floor (* 2 (expt cube-size 3)) (* 3 pi (expt diameter 2)))))

(defconstant slices-per-pizza 8)
(defun fair-share-p (pizzas friends) (zerop (mod (* pizzas slices-per-pizza) friends)))
