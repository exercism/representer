(defpackage :matrix
  (:use :cl)
  (:export :row
           :column))

(in-package :matrix)

(defun process-line (line &optional (acc (list)))
  (if (zerop (length line))
      (reverse acc)
      (multiple-value-bind (n len) (parse-integer line :junk-allowed t)
        (process-line (subseq line len) (cons n acc)))))

(defun process-lines (str &optional (acc (list)))
  (if (zerop (length str))
      (reverse acc)
      (let* ((len (position #\Newline str :test #'char=))
             (ss (subseq str 0 len)))
        (process-lines (subseq str (1+ len)) (cons (process-line ss) acc)))))

(defun create-matrix (str)
  "Converts 'str' (a string-based matrix format) into an actual matrix using
common-lisp's built-in #2A(()) arrays."
  (let* ((str-as-list (process-lines str))
         (rows (length str-as-list))
         (cols (length (first str-as-list))))
    (make-array (list rows cols) :initial-contents str-as-list)))

(defun find-row (matrix n)
  "Returns a list of the elements in the nth row of matrix, beginning at 0."
  (let* ((index (second (array-dimensions matrix)))
         (start (* index n))
         (end (1- (+ start index))))
    (loop for i from start to end
          collect (row-major-aref matrix i))))

(defun row (input-matrix index)
  (if (= 1 (length input-matrix))
      (list (parse-integer input-matrix :junk-allowed t))
      (let ((matrix (create-matrix input-matrix)))
        (find-row matrix (1- index)))))

(defun find-col (matrix index)
  "Returns a list of the elements in the index'th column of matrix, beginning at 0."
  (loop for c from 0 to (1- (first (array-dimensions matrix)))
        collect (aref matrix c index)))

(defun column (input-matrix index)
  (if (= 1 (length input-matrix))
      (list (parse-integer input-matrix :junk-allowed t))
      (let ((matrix (create-matrix input-matrix)))
        (find-col matrix (1- index)))))
