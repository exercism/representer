(defpackage :matrix
  (:use :cl)
  (:export :row
           :column))

(in-package :matrix)

(defun row (input-matrix index)
  (let ((matrix (parse-matrix input-matrix)))
    (elt matrix (1- index))))

(defun column (input-matrix index)
  (let ((matrix (parse-matrix input-matrix)))
    (decf index)
    (map 'list (lambda (row) (elt row index)) matrix)))

(defun parse-matrix (matrix)
  (map 'list #'parse-row (split-rows matrix)))

(defun split-rows (matrix)
  (let ((rows (list))
        (start 0)
        (end 0))
    (loop
      (when (> end (length matrix)) (return (reverse rows)))
      (setf end (position #\Newline matrix :start start))
      (when (null end) (setf end (length matrix)))
      (push (subseq matrix start end) rows)
      (setf start (1+ end))
      (incf end 2))))

(defun parse-row (row)
  (let ((items (list))
        (start 0)
        (end 0))
    (loop
      (when (>= end (length row)) (return (reverse items)))
      (setf end (position #\Space row :start start))
      (when (null end) (setf end (length row)))
      (push (parse-integer (subseq row start end)) items)
      (setf start (1+ end))
      (incf end 2))))
