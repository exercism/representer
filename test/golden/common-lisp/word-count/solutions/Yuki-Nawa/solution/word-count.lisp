(defpackage :word-count
  (:use :cl)
  (:export :count-words))
(in-package :word-count)



(defun count-words (sentence)
  "Only ASCII characters.
   Words are case insensitive."
  (flet ((first-word (i)
                     (string-trim "'" (subseq (string-downcase sentence)
                                              i
                                              (position-if (lambda (char)
                                                                   (not (or (alphanumericp char)
                                                                            (char= #\' char))))
                                                           sentence
                                                           :start i)))))
    (let ((word-list   (loop for i below (length sentence)
                             if (alphanumericp (char sentence i))
                             collect (first-word i)
                             and do (setf i (+ i (length (first-word i)))))))
      (loop while (plusp (length word-list))
            collect (cons (car word-list) (count (car word-list) word-list :test #'equalp))
            do (setf word-list (remove (car word-list) word-list :test #'equalp))))))
