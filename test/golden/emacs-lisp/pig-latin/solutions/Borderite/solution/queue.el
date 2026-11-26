;;; queue.el --- Accumulate (exercism)  -*- lexical-binding: t; -*-

(defun make-queue ()
  (let ((queue (list nil)))
    (setf (car queue) queue)))

(defun enqueue (item queue)
  (let ((last-cell (list item)))
    (setf (cdr (car queue)) last-cell
          (car queue) last-cell))
  item)

(defun dequeue (queue)
  (prog1
    (cadr queue)
    (setf (cdr queue) (cddr queue))
    (when (null (cdr queue))
      (setf (car queue) queue))))

(defun queue-emptyp (queue)
  (not (cdr queue)))

(defun queue-not-empty (queue)
  (cdr queue))

(defun queue-to-list (queue)
  (cdr queue))

(provide 'queue)
