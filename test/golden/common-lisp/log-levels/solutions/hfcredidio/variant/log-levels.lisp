(defpackage :log-levels
  (:use :cl)
  (:export :log-message :log-severity :log-format))

(in-package :log-levels)

(defun log-message (log-string)
  (let ((i (position #\: log-string)))
       (subseq log-string (- i 2))))

(defun log-severity (log-string)
  (let* ((i (position #\] log-string))
         (raw-severity (subseq log-string 1 i))
         (severity (string-downcase raw-severity)))
        (cond
          ((string= severity "info") :everything-ok)
          ((string= severity "warn") :getting-worried)
          ((string= severity "ohno") :run-for-cover)
          (t severity))))

(defun log-format (log-string)
  (let ((message (log-message log-string))
        (severity (log-severity log-string)))
       (case severity
         (:everything-ok (string-downcase message))
         (:getting-worried (string-capitalize message))
         (:run-for-cover (string-upcase message)))))