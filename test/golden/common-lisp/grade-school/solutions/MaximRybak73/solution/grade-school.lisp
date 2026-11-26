(defpackage :grade-school
  (:use :cl)
  (:export :make-school :add :roster :grade))

(in-package :grade-school)

;; Структура для хранения информации о школе
(defstruct school-data
  (students (make-hash-table :test 'equal) :type hash-table)
  (all-students (make-hash-table :test 'equal) :type hash-table))

(defun make-school ()
  "Создаёт новую школу."
  (make-school-data :students (make-hash-table :test 'equal)
                    :all-students (make-hash-table :test 'equal)))

(defun add (school name grade-num)
  "Добавляет ученика в школу. 
   Возвращает T если успешно, NIL если ученик уже добавлен."
  (let ((all-students (school-data-all-students school)))
    ;; Проверяем, есть ли уже такой ученик
    (if (gethash name all-students)
        nil  ;; Ученик уже существует
        (progn
          ;; Добавляем ученика в класс
          (let* ((students (school-data-students school))
                 (grade-list (gethash grade-num students '())))
            (setf (gethash grade-num students) (cons name grade-list)))
          ;; Отслеживаем, что ученик добавлен
          (setf (gethash name all-students) grade-num)
          t))))

(defun grade (school grade-num)
  "Возвращает отсортированный список учеников в классе."
  (let ((students (school-data-students school)))
    (let ((names (gethash grade-num students '())))
      (sort (copy-list names) #'string<))))

(defun roster (school)
  "Возвращает отсортированный список всех учеников всех классов."
  (let ((students (school-data-students school))
        (grades-list '()))
    ;; Собираем все номера классов
    (maphash (lambda (key value)
               (declare (ignore value))
               (push key grades-list))
             students)
    ;; Сортируем классы по возрастанию
    (setq grades-list (sort grades-list #'<))
    ;; Собираем учеников всех классов в порядке классов
    (let ((result '()))
      (dolist (grade-num grades-list)
        (let ((names (grade school grade-num)))
          (setq result (append result names))))
      result)))
