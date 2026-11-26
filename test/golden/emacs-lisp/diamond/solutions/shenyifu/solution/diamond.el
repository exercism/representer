;;; diamond.el --- Diamond (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun rows (letter)
  (let* ((first-part-count (+ 1
                              (- letter ?A)))
         (current-line 1)
         (result (vector)))
    (while (<= current-line first-part-count)
      (setq result (vconcat result
                            (vector (line current-line letter))))
      (setq current-line (+ 1 current-line)))
    (setq current-line (-  current-line 1))
    (while (> current-line 1)
      (setq current-line (- current-line 1))
      (setq result (vconcat result
                            (vector (line current-line letter)))))
    result)
    )


(defun line (current-line letter)
  (let* ((current-space-count (+ 1
                                 (- letter ?A current-line)))
         (current-space-middle-count (max 0
                                          (- (* 2 current-line)
                                             3)))
         (current-letter (byte-to-string (+ (- current-line 1)
                                            ?A)))
         (result "")
         (prefix-space (make-string current-space-count ? ))
         (middle-space (make-string current-space-middle-count ? )))
    (if (= 1 current-line)
        (concat prefix-space "A" prefix-space)
      (concat prefix-space current-letter middle-space
              current-letter prefix-space))))

(provide 'diamond)
;;; diamond.el ends here

