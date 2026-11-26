;;; grains.el --- Grains exercise (exercism)  -*- lexical-binding: t; -*-

(defun square (n)
  (ash 1 (1- n)))

(defun total ()
  (1- (square 66)))

(provide 'grains)
;;; grains.el ends here
