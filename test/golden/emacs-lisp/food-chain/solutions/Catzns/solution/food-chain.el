;;; food-chain.el --- Food Chain (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defconst lines [("fly" . "I don't know why she swallowed the fly. Perhaps she'll die.")
                 ("spider" . "It wriggled and jiggled and tickled inside her.")
                 ("bird" . "How absurd to swallow a bird!")
                 ("cat" . "Imagine that, to swallow a cat!")
                 ("dog" . "What a hog, to swallow a dog!")
                 ("goat" . "Just opened her throat and swallowed a goat!")
                 ("cow" . "I don't know how she swallowed a cow!")
                 ("horse" . "She's dead, of course!")])

(defun verse (l)
  (let ((swallow1 (aref lines (cl-decf l))) swallow2 r)
    (push (format "I know an old lady who swallowed a %s." (car swallow1)) r)
    (push (format "%s" (cdr swallow1)) r)
    (when (and (> l 0) (< l 7))
      (cl-loop
       while (> l 0) do
       (setq swallow2 swallow1
             swallow1 (aref lines (cl-decf l)))
       (push (format "She swallowed the %s to catch the %s%s."
                     (car swallow2) (car swallow1)
                     (if (= l 1) " that wriggled and jiggled and tickled inside her" "")) r))
      (push (cdr (aref lines 0)) r))
    (nreverse r)))

(defun recite (start-verse end-verse)
  (cl-loop for i from start-verse to end-verse
           collect "" into r
           append (verse i) into r
           finally return (cdr r)))

(provide 'food-chain)
;;; food-chain.el ends here

