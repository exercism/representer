(defpackage :matrix
  (:use :cl)
  (:export :row
           :column))

(in-package :matrix)


(defun split-items (input-matrix &key (separator #\Space))
  (let ((end (length input-matrix)))
    (loop
      for start = 0 then (1+ pos)
      for pos = (position separator input-matrix :start start)
      when (and (null pos)
                (not (= start end)))
        collect (subseq input-matrix start)
      while pos
      when (> pos start)
        collect (subseq input-matrix start pos))))


(defun split-rows (input-matrix)
  (split-items input-matrix :separator #\Newline))


(defun convert-to-matrix (input-matrix)
  (mapcar #'split-items (split-rows input-matrix)))


(defun row (input-matrix index)
  (mapcar #'parse-integer (nth (1- index) (convert-to-matrix input-matrix))))


(defun column (input-matrix index)
  (mapcar (lambda (row)
            (parse-integer (nth (1- index) row)))
          (convert-to-matrix input-matrix)))
