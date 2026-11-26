(defpackage :bob
  (:use :cl)
  (:export :response))
(in-package :bob)

(defun question-p (sentence)
  (let ((len (length sentence)))
    (and (plusp len)
         (char= #\? (char sentence (1- len))))))

(defun yell-p (sentence)
  (and (some #'alpha-char-p sentence)
       (notany #'lower-case-p sentence)))

(defun response (hey-bob)
  (let* ((sentence (string-trim
                   '(#\Tab #\Newline #\Vt #\Page #\Return #\Space)
                   hey-bob))
         (question (question-p sentence))
         (yell (yell-p sentence)))
    (cond ((zerop (length sentence))
           "Fine. Be that way!")
          ((and question yell)
           "Calm down, I know what I'm doing!")
          (question
           "Sure.")
          (yell
           "Whoa, chill out!")
          (t
           "Whatever."))))
