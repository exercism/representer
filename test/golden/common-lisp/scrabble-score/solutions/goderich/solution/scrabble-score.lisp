(defpackage #:scrabble-score
  (:use #:cl)
  (:export #:score-word))

(in-package #:scrabble-score)

(defun score-letter (c)
  "Return the score for a single letter."
  (cond
    ((find c "aeioulnrst") 1)
    ((find c "dg") 2)
    ((find c "bcmp") 3)
    ((find c "fhvwy") 4)
    ((find c "k") 5)
    ((find c "jx") 8)
    ((find c "qz") 10)))

(defun score-word (word)
  "Computes the score for an entire word."
  (loop :for letter
        :across (string-trim '(#\Space #\Newline) (string-downcase word))
        :sum (score-letter letter)))
