;;; crypto-square.el --- Crypto Square (exercism)

;;; Commentary:

;;; Code:

(defun crypto-square--split-string-by-length (text chunk-size)
  (unless (= 0 (length text))
    (let ((chunk-length (if (> (length text) chunk-size) chunk-size (length text))))
      (if (< chunk-length chunk-size)
          (list (substring text 0 chunk-length))
        (append (list (substring text 0 chunk-length))
                (crypto-square--split-string-by-length (substring text chunk-length) chunk-size))))))

(defun crypto-square--transpose (chunks chunk-size)
  (let ((chunks-as-vectors (mapcar 'vconcat chunks)))
    (mapcar #'(lambda (pos)
                (mapconcat #'(lambda (chunk)
                               (if (< pos (length chunk))
                                   (string (aref chunk pos))
                                 " ")) chunks-as-vectors ""))
            (number-sequence 0 (1- chunk-size)))))

(defun encipher (in-text)
  (let* ((scrubbed-text (replace-regexp-in-string "[^a-z0-9]" "" (downcase in-text)))
         (square-size (ceiling (sqrt (length scrubbed-text))))
         (chunks (crypto-square--split-string-by-length scrubbed-text square-size))
         (transposed-chunks (crypto-square--transpose chunks square-size)))
    (mapconcat 'identity transposed-chunks " ")))
         
                        


(provide 'crypto-square)
;;; crypto-square.el ends here
