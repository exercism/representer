;;; secret-handshake.el --- Secret Handshake (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun to-binary-string (number)
  "Convert NUMBER to a binary string."
  (let ((result ""))
    (while (> number 0)
      (setq result (concat (if (zerop (mod number 2)) "0" "1") result))
      (setq number (floor number 2)))
    (setq result (concat (make-string (- 5 (length result)) ?0) result))
    result))

(defun commands (number)
  "Convert NUMBER to a sequence of secret handshake commands."
  (let* ((binary (reverse (string-to-list (to-binary-string number))))
         (actions '("wink" "double blink" "close your eyes" "jump"))
         (result (let (res)
                   (dotimes (i 4)
                     (when (eq (elt binary i) ?1)
                       (push (nth i actions) res)))
                   (nreverse res))))
    (if (eq (elt binary 4) ?1)
        (reverse result)
      result)))

(provide 'secret-handshake)
;;; secret-handshake.el ends here
