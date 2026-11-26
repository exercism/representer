(defpackage :crypto-square
  (:use :cl)
  (:export :encipher))
(in-package :crypto-square)

(defun clean-text (plaintext)
  "Clean text of non-alphanumerics."
  (string-downcase (remove-if-not #'alphanumericp plaintext)))

(defun encipher (plaintext)
  "turn plaintext into formatted cipher."
  (labels ((collect-row (stream cleaned length column-count i)
             "collect each row of the cipher matrix."
             (loop for j from 0 to (1- length) by column-count
                   while (< (+ i j) length)
                   do
                      (format stream "~c" (aref cleaned (+ i j)))))
           (pad-row (stream column filler-space-count i)
             "pad the given matrix row with spaces."
             (when (and
                    (not (zerop filler-space-count))
                    (> i (- (1- column) filler-space-count)))
               (format stream " "))))
    (flet ((make-cipher (cleaned length)
             "make a cipher so that it forms as even a square matrix as possible."
             (let* ((column-count (ceiling (sqrt length)))
                    (row-count (ceiling (* length column-count)))
                    (filler-space-count (- (* column-count row-count) length)))
               (loop for i from 0 to (1- column-count)
                     collect
                     (with-output-to-string (stream)
                       (collect-row stream cleaned length column-count i)
                       (pad-row stream column-count filler-space-count i)))))
           (format-cipher (cipher)
             "format the cipher so that it has spaces between each column."
             (with-output-to-string (stream)
               (format stream "~{~a~^ ~}" cipher))))
      (let* ((cleaned (clean-text plaintext))
             (length (length cleaned)))
        (if (zerop length)
            ""
            (format-cipher (make-cipher cleaned length)))))))
