(defpackage :house
  (:use :cl)
  (:export :recite))

(in-package :house)

(defun recite (start-verse end-verse)
  (let ((result (get-verse start-verse))
        (verse (1+ start-verse)))
       (loop while (< verse end-verse) do
             (setf result (concatenate 'string result (string #\newline) (get-verse verse)))
             (setf verse (1+ verse)))
       result))

(defun get-verse (verse)
  (let ((text (make-array 12
                          :initial-contents
                          '("the house that Jack built"
                            "the malt that lay in"
                            "the rat that ate"
                            "the cat that killed"
                            "the dog that worried"
                            "the cow with the crumpled horn that tossed"
                            "the maiden all forlorn that milked"
                            "the man all tattered and torn that kissed"
                            "the priest all shaven and shorn that married"
                            "the rooster that crowed in the morn that woke"
                            "the farmer sowing his corn that kept"
                            "the horse and the hound and the horn that belonged to")))
        (result "This is"))
       (loop while (> verse 0) do
              (setf result (concatenate 'string result " " (aref text (1- verse))))
              (setf verse (1- verse)))
       (concatenate 'string result ".")))
