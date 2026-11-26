(defmodule matching-brackets
  (export (paired? 2)))

;; just practicing with macros to create an `in` operator like Elixir has,
;; which can be used in guard clauses, unlike lists:member
(defmacro in (item list)
  `(or ,@(lists:map (lambda (elem) `(== ,elem ,item)) list)))

(defun paired? (s)
  (fletrec
    ((check-stack (top stack rest)
       (andalso
         (/= stack '())
         (== (car stack) top)
         (loop (cdr stack) (cdr rest))))
     (loop (stack rest)
       (if (== rest '()) (== stack '())
         (case (car rest)
           (#\} (check-stack #\{ stack rest))
           (#\] (check-stack #\[ stack rest))
           (#\) (check-stack #\( stack rest))
           (x (when (in x "([{"))
             (loop (cons x stack) (cdr rest)))
           (x (loop stack (cdr rest)))))))
    (loop '() s)))
