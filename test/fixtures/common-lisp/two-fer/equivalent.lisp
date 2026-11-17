;; Two-fer, written with different names, layout and comments.
(DEFPACKAGE #:two-fer
  (:EXPORT #:two-for-one)
  (:USE :COMMON-LISP))

(IN-PACKAGE #:TWO-FER)

(defun Two-For-One (&optional (person nil))
  "Says who the cookie is for."
  (cl:format nil "One for ~a, one for me." (or person "you")))
