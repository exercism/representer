(defpackage :log-levels
  (:use :cl)
  (:export :log-message :log-severity :log-format))

(in-package :log-levels)

(defun log-message (log-string)
  (let ((message-start (+ 2 (position #\: log-string))))
    (subseq log-string message-start)))

(defun log-severity (log-string)
  (let* ((level-start (1+ (position #\[ log-string)))
         (level-end (position #\] log-string))
         (level (subseq log-string level-start level-end)))
    (cond ((string-equal level "info") :everything-ok)
          ((string-equal level "warn") :getting-worried)
          ((string-equal level "ohno") :run-for-cover)
          (t nil))))

(defun log-format (log-string)
  (let ((severity (log-severity log-string))
        (message (log-message log-string)))
    (funcall (case severity
               (:everything-ok #'string-downcase)
               (:getting-worried #'string-capitalize)
               (:run-for-cover #'string-upcase)
               (otherwise #'identity))
             message)))
