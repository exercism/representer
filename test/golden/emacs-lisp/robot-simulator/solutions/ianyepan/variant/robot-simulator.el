;;; robot-simulator.el --- robot-simulator (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(cl-defstruct robot
  x y direction)

(defconst robot--dirs [north east south west])

(defconst robot--offsets
  #s(hash-table test eq
                data (north (1  . 1)
                      east  (1  . 0)
                      south (0  . -1)
                      west  (-1 . 0))))

(defun robot--turn (curr-dir turn)
  (let ((len (length robot--dirs))
        (pos (cl-position curr-dir robot--dirs)))
    (if (= turn ?R)
        (aref robot--dirs (% (1+ pos) len))
      (aref robot--dirs (% (+ len (1- pos)) len)))))

(defun create-robot (x y direction)
  (make-robot :x x :y y :direction direction))

(defun move (robot instructions)
  (seq-doseq (c instructions)
    (if (/= c ?A)
        (setf (robot-direction robot)
              (robot--turn (robot-direction robot) c))
      (let ((offset (gethash (robot-direction robot) robot--offsets)))
        (cl-incf (robot-x robot) (car offset))
        (cl-incf (robot-y robot) (cdr offset)))))
  robot)


(provide 'robot-simulator)
;;; robot-simulator.el ends here
