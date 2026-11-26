(defpackage :hamming
  (:use :cl)
  (:export :distance))

(in-package :hamming)

(defun distance (strand1 strand2)
  "Вычисляет расстояние Хэмминга между двумя цепочками ДНК.
   
   Возвращает количество позиций, в которых символы отличаются.
   Если строки разной длины, возвращает NIL."
  
  ;; Проверяем, что длины строк одинаковы
  (unless (/= (length strand1) (length strand2))
    (return-from distance nil))
  
  ;; Подсчитываем различия
  (let ((count 0))
    (dotimes (i (length strand1) count)
      (when (char/= (char strand1 i) (char strand2 i))
        (incf count)))))