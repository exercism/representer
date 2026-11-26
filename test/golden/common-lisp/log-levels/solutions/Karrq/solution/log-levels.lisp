(defpackage :log-levels
  (:use :cl)
  (:export :log-message :log-severity :log-format))

(in-package :log-levels)

(defun trim-whitespace (string)
  (string-trim '(#\Space #\Tab #\Newline) string))

;(log-message "[ohno]: whoops!") ; => "whoops!"
(defun log-message (log-string)
  (let ((pos (position #\: log-string)))
    (trim-whitespace (subseq log-string (1+ pos)))))

#|
The level of the log string determines its severity.

    a level of info means a severity of :everything-ok
    a level of warn means a severity of :getting-worried
    a level of ohno means a severity of :run-for-cover

Also should handle:
    (log-severity "[WaRn]: string case system failing") ; => :getting-worried
|#
(defun log-severity (log-string)
  (let ((log-string (string-downcase log-string)))
    (cond
      ((eq 0 (search "[info]:" log-string)) :everything-ok)
      ((eq 0 (search "[warn]:" log-string)) :getting-worried)
      ((eq 0 (search "[ohno]:" log-string)) :run-for-cover)
      (t nil))))

(defun log-format (log-string)
  (funcall
   (case (log-severity log-string)
    (:everything-ok #'string-downcase)
    (:getting-worried #'string-capitalize)
    (:run-for-cover #'string-upcase)
    (otherwise #'identity))
   (log-message log-string)))