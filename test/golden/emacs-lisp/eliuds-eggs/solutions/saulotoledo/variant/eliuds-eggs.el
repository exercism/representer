;;; eliuds-eggs.el --- Eliud's Eggs (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun int-to-binary-string (n)
  "Convert the integer N to a binary string."
  (if (= n 1)
      "0"
    (let ((res ""))
      (while (> n 0)
        (setq res (concat (number-to-string (% n 2)) res))
        (setq n (/ n 2)))
      res)))

(defun egg-count (number)
  "Count the eggs by calculating the Hamming weight of NUMBER.
Converts the display's decimal number to binary and counts the number of
active bits (1s), where each 1 represents a collected egg."
  (let ((num-as-binary (int-to-binary-string number))
        (count 0))
    (dotimes (i (length num-as-binary))
      (let ((char (aref num-as-binary i)))
        (when (= char ?1)
          (setq count (+ count 1)))))
    count))

(provide 'eliuds-eggs)
;;; eliuds-eggs.el ends here
