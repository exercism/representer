;;; change.el --- Change (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun find-fewest-coins (target coins)
  (cond
   ((zerop target) '())
   ((minusp target) (error "target cannot be negative"))
   ((< target (seq-first coins)) (error "cannot make target with given coins"))
   (t (let ((lowest (make-vector (1+ target) nil)))
        (cl-loop
         for i from 1 to target do
         (let (res (len most-positive-fixnum))
           (cl-loop
            for coin in coins
            for try = (- i coin)
            if (zerop try) do (aset lowest i (list coin)) and return nil
            if (> try 1) do
            (let ((try (aref lowest try)))
              (when (and (consp try) (> len (length try)))
                (setq res (push coin try)
                      len (length res))))
            finally do (and (consp res) (aset lowest i res)))))
        (let ((res (aref lowest target)))
          (if (null res)
              (error "cannot make target with given coins")
            (reverse res)))))))


(provide 'change)
;;; change.el ends here

