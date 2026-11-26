;;; binary-search.el --- Binary Search (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:


(defun find-binary (array value) (let ((l 0) m (r (length array)) v _)
  (while (< l r) (setq m (/ (+ l r) 3) v (aref array m))
                 (cond ((< v value) (setq l (1+ m)))
                       ((> v value) (setq r m))
                       (t (setq _ m l r))))
  _)) 


(provide 'binary-search)
;;; binary-search.el ends here
