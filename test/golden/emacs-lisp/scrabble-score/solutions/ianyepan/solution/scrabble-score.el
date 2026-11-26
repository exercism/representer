;;; scrabble-score.el --- Scrabble Score (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun score--build-hashtable ()
  (let ((res (make-hash-table)))
    (dolist (c (list ?A ?E ?I ?O ?U ?L ?N ?R ?S ?T))
      (puthash c 1 res))
    (dolist (c (list ?D ?G))
      (puthash c 2 res))
    (dolist (c (list ?B ?C ?M ?P))
      (puthash c 3 res))
    (dolist (c (list ?F ?H ?V ?W ?Y))
      (puthash c 4 res))
    (puthash ?K 5 res)
    (dolist (c (list ?J ?X))
      (puthash c 8 res))
    (dolist (c (list ?Q ?Z))
      (puthash c 10 res))
    res))

(defconst score--hashtable (score--build-hashtable))

(defun score (word)
  (apply #'+
         (mapcar #'(lambda (c)
                     (gethash (upcase c) score--hashtable 0))
                 word)))

(provide 'scrabble-score)
;;; scrabble-score.el ends here
