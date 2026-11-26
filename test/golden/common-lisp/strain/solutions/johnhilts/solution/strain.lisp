(defpackage #:strain
  (:use #:common-lisp)
  (:export #:keep #:discard))

(in-package #:strain)

(defun remove-from (collection
                    &key
                      ((:when when-predicate) nil when-supplied-p)
                      ((:unless unless-predicate) nil unless-supplied-p))
  (labels
      ((remove-from-r (collection predicate remove-matching)
         (cond
           ((null collection) nil)
           (t
            (let* ((current-item (car collection))
                   (rest (cdr collection))
                   (is-match-current-item (funcall predicate current-item))
                   (remove-from-rest #'(lambda ()
                                         (remove-from-r rest predicate remove-matching)))
                   (discard-current #'(lambda ()
                                        (funcall remove-from-rest)))
                   (keep-current #'(lambda ()
                                     (cons current-item (funcall remove-from-rest)))))
              (if remove-matching
                  (if is-match-current-item
                      (funcall discard-current)
                      (funcall keep-current))
                  (if is-match-current-item
                      (funcall keep-current)
                      (funcall discard-current))))))))
    (let ((predicate (if when-supplied-p when-predicate unless-predicate)))
      (remove-from-r collection predicate when-supplied-p))))
        
(defun keep (predicate collection)
  (remove-from collection :unless predicate))

(defun discard (predicate collection)
  (remove-from collection :when predicate))
