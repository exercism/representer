(defpackage :pig-latin
  (:use :cl)
  (:export :translate))

(in-package :pig-latin)

(defun vowelp (c)
  (when (member c '(#\a #\e #\i #\o #\u)) t))

(defun consonantp (c) (not (vowelp c)))

(defun consume-consonants (cs)
  (let ((lookahead (append (cdr cs) '(nil))))
    (loop for c in cs
          for d in lookahead
          for i from 0
          while (consonantp c)
          collect c into consonants
          do (when (or (eql #\u d) (eql #\y d))
               (return (values consonants (1+ i))))
          finally (return (values consonants i)))))

(defun zero-rot-p (cs)
  (let ((fst-two (subseq cs 0 2)))
    (cond ((vowelp (car cs)) t)
          ((equal '(#\y #\t) fst-two) t)
          ((equal '(#\x #\r) fst-two) t))))

(defun by-how-much-to-rotate (cs)
  (if (zero-rot-p cs)
      0
      (multiple-value-bind (consonants i) (consume-consonants cs)
        (let ((last-consonant (car (last consonants)))
              (after-consonant (nth i cs)))
          (cond ((and (char= #\q last-consonant) (char= #\u after-consonant))
                 (1+ i))
                (t i))))))

(defun rotate (cs k)
  (let ((p1 (subseq cs 0 k))
        (p2 (subseq cs k)))
    (append p2 p1)))

(defun translate-word (word)
  (let* ((cs (coerce word 'list))
         (k (by-how-much-to-rotate cs))
         (rotated (rotate cs k)))
    (coerce (append rotated '(#\a #\y)) 'string)))

(defun translate (phrase)
  (let* ((words (uiop:split-string phrase))
         (translated-words (mapcar #'translate-word words)))
    (format nil "~{~a~^ ~}" translated-words)))
