(defpackage :luhn
  (:use :cl)
  (:export :validp))

(in-package :luhn)

(defun validp (input)
  (unless (every (lambda (char) (or (digit-char-p char) (char= char #\Space))) input)
    (return-from validp nil))
  
  (let ((cleaned (remove #\Space input)))
    (when (<= (length cleaned) 1)
      (return-from validp nil))
    
    (let ((sum 0)
          (position 1)) (loop for i from (1- (length cleaned)) downto 0 do
        (let ((digit (digit-char-p (char cleaned i))))
          (if (evenp position)
              (let ((doubled (* digit 2)))
                (if (> doubled 9)
                    (incf sum (- doubled 9))
                    (incf sum doubled)))
              (incf sum digit))
          (incf position)))
      (= (mod sum 10) 0))))