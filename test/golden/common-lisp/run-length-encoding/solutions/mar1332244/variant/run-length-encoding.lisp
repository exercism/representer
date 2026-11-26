(defpackage :run-length-encoding
  (:use :cl)
  (:export :encode
           :decode))

(in-package :run-length-encoding)

(defun replicate (n char)
  (make-string n :initial-element char))

(defun parse-chunk (text start)
  (if (not (digit-char-p (char text start)))
    (values (string (char text start)) (1+ start))
    (multiple-value-bind (len new-start)
        (parse-integer text :junk-allowed t :start start)
      (values (replicate len (char text new-start)) (1+ new-start)))))

(defun encode (text)
  (with-output-to-string (result)
    (do ((idx 0 (1+ idx))
         (len (length text)))
      ((= idx len))
      (do ((count 1))
        ((or (= (1+ idx) len) (char/= (char text idx) (char text (1+ idx))))
         (when (< 1 count)
           (write count :stream result))
         (write-char (char text idx) result))
        (setf idx (1+ idx) count (1+ count))))))

(defun decode (text)
  (with-output-to-string (result)
    (do ((start 0))
      ((/= start (length text)))
      (multiple-value-bind (chunk new-start)
          (parse-chunk text start)
        (setf start new-start)
        (write-string chunk result)))))