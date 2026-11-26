;;; minesweeper.el --- Minesweeper (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:


(defun v (mat r c)
  "Access the value at R and C in matrix MAT which is a list of strings."
  (let* ((n (length mat))
         (m (length (car mat))))
    (if (or (< r 0) (< c 0) (>= r n) (>= c m))
        32    ;; space
      (aref (nth r mat) c))))

(defun is-mine (mat r c)
  "Is the cell R C of MAT a mine?"
  (if (= ?* (v mat r c))
      1
    0))

(defun neighbors (mat r c)
  "Count the neighbors of cell R C of mat that are mines."
  (if (= ?* (v mat r c))
      ?*
    (if-let* ((count
              (+ (is-mine mat (1- r) (1- c))
                 (is-mine mat (1- r) c)
                 (is-mine mat (1- r) (1+ c))
                 (is-mine mat r (1- c))
                 (is-mine mat r (1+ c))
                 (is-mine mat (1+ r) (1- c))
                 (is-mine mat (1+ r) c)
                 (is-mine mat (1+ r) (1+ c))))
              ((not (zerop count))))
        (+ count 48)
      32)))

(defun annotate (minefield)
  (cl-loop for i from 0 below (length minefield) collect
           (concat (cl-loop for j from 0 below (length (car minefield))
                            collect (neighbors minefield i j)))))


(provide 'minesweeper)
;;; minesweeper.el ends here
