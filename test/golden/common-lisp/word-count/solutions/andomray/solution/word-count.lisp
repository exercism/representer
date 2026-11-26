(defpackage :word-count
  (:use :cl)
  (:export :count-words))

(in-package :word-count)

(defun clean-word (str)
  (loop for c across str
        when (or (alphanumericp c) (char= #\' c))
          collect c into char-list
        finally (return (coerce char-list 'string))))

(defun split-string (str)
  (loop for i = 0 then (1+ j)
        as j = (or (position #\Space str   :start i :test-not #'char/=)
                   (position #\Comma str   :start i :test-not #'char/=)
                   (position #\Newline str :start i :test-not #'char/=)
                   (position #\Tab str     :start i :test-not #'char/=))
        collect (subseq str i j)
        while j))

(defun count-instances (word word-list)
  (cons word (count word word-list :test #'string=)))

(defun do-count-words (unique-words all-words &optional (results (list)))
  (if (null unique-words)
      results
      (let ((result (count-instances (first unique-words) all-words)))
        (do-count-words (rest unique-words) all-words (cons result results)))))

;; I should pull these out into a function or two, but...
(defun count-words (sentence)
  (let* ((words (split-string (string-downcase sentence)))
         (only-words (remove "" words :test #'string=))
         (clean-words (mapcar #'clean-word only-words))
         (parsed-words (mapcar #'(lambda (s) (string-trim '(#\') s)) clean-words))
         (unique-words (remove-duplicates parsed-words :test #'string=)))
    (do-count-words unique-words parsed-words)))
