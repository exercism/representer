;;; binary-search.el --- Binary Search (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun find-binary-index (array value offset)
  (let* ((len (length array))
	 (mid (/ len 2))
	 (upper (nthcdr mid array))
	 (v (car upper)))
    (when array
      (if (= v value)
	  (+ offset mid)
	(when (/= len 1)
	  (if (< value v)
	      (find-binary-index (butlast array (- len mid)) value offset)
	    (find-binary-index upper value (+ offset mid))))))))

(defun find-binary (array value)
  (find-binary-index (append array nil) value 0))

(provide 'binary-search)
;;; binary-search.el ends here
