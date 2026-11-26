;;; sublist.el --- Sublist (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun sublistp (l1 l2)
  (when (>= (length l2) (length l1))
    (or (equal l1 (seq-take l2 (length l1)))
        (sublistp l1 (car l2)))))

(defun list-classify (list1 list2)
  (cond
   ((equal list1 list2) :equal)
   ((sublistp list1 list2) :sublist)
   ((sublistp list2 list1) :superlist)
   (t :unequal)))

(provide 'sublist)
;;; sublist.el ends here
