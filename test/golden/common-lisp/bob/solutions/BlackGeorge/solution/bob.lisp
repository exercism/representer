(defpackage :bob
  (:use :cl)
  (:export :response))
(in-package :bob)


(defun clean-string (a-string)
  "Cleans up A-STRING for further processing."
  (when (> (length a-string) 1)
    (string-trim '(#\Space #\Newline #\Tab) a-string)))


(defun all-caps-p (a-string)
  "Returns T if A-STRING is in all caps, NIL otherwise."
  (and (some #'alpha-char-p a-string)
       (string= a-string (string-upcase a-string))))


(defun last-char (a-string)
  "Returns the last character of A-STRING."
  (when (> (length a-string) 1)
    (char a-string (1- (length a-string)))))

(defun response (hey-bob)
  "Returns responses from Bob based on input."
  (let ((trimmed-string (clean-string hey-bob)))
    (cond ((zerop (length trimmed-string))
           (format nil "Fine. Be that way!"))
          ((and (all-caps-p trimmed-string)
                (char= #\? (last-char trimmed-string)))
           (format nil "Calm down, I know what I'm doing!"))
          ((char= #\? (last-char trimmed-string))
           (format nil "Sure."))
          ((all-caps-p trimmed-string)
           (format nil "Whoa, chill out!"))
          (t (format nil "Whatever.")))))
