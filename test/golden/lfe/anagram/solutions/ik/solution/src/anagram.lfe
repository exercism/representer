(defmodule anagram
  (export (find 2)))

(defun find (word candidates)
  (let* ((normalised-word (normalise-case word))
         (word-letters (for-anagram normalised-word)))
    (lists:filter
      (lambda (candidate)
        (let ((normalised-candidate (normalise-case candidate)))
          (and
            (/= normalised-word normalised-candidate)
            (==
              (for-anagram normalised-candidate)
              word-letters))))
      candidates)))

(defun normalise-case (word)
  (string:uppercase word))

(defun for-anagram (normalised-word)
  (lists:sort normalised-word))
