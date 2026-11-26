(defun word-char-p (x)
  (= (char-syntax x) ?\w))

(defun count-chars-from-stdin ()
  (let ((table (make-hash-table :test #'eq))
        (string (with-temp-buffer
                  (insert-file-contents "/dev/stdin")
                  (buffer-string))))
    (dotimes (i (length string))
      (let ((x (aref string i)))
        (when (word-char-p x)
          (setf x (downcase x)
                (gethash x table) (1+ (gethash x table 1))))))
    (prin1 table)))


