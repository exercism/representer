(defpackage :meetup
  (:use :cl)
  (:export :meetup))

(in-package :meetup)

(defun meetup (month year dayofweek week)
  "Находит дату встречи.
   dayofweek: :monday, :tuesday, ... :sunday
   week: :first, :second, :third, :fourth, :last, :teenth
   Возвращает список (year month day)"
  
  ;; Преобразуем имена дней недели в числа (0=Monday, 6=Sunday)
  (let ((day-num (case dayofweek
                   (:monday 0)
                   (:tuesday 1)
                   (:wednesday 2)
                   (:thursday 3)
                   (:friday 4)
                   (:saturday 5)
                   (:sunday 6))))
    
    ;; Получаем день месяца в зависимости от типа недели
    (let ((day (case week
                 (:teenth (get-teenth-day month year day-num))
                 (:first (get-nth-week-day month year day-num 0))
                 (:second (get-nth-week-day month year day-num 1))
                 (:third (get-nth-week-day month year day-num 2))
                 (:fourth (get-nth-week-day month year day-num 3))
                 (:last (get-last-week-day month year day-num)))))
      ;; Возвращаем список (year month day)
      (list year month day))))

(defun get-day-of-week (day month year)
  "Возвращает день недели (0=Monday, 6=Sunday) для указанной даты.
   Используется алгоритм Зеллера."
  (let* ((m (if (< month 3) (+ month 12) month))
         (y (if (< month 3) (- year 1) year))
         (k (mod y 100))
         (j (floor y 100))
         (h (mod (+ day
                    (floor (* 13 (+ m 1)) 5)
                    k
                    (floor k 4)
                    (floor j 4)
                    (- (* 2 j)))
                 7)))
    ;; Преобразуем в формат (0=Monday, 6=Sunday)
    (mod (+ h 5) 7)))

(defun get-teenth-day (month year day-num)
  "Находит день 'teenth' (13-19) заданного дня недели."
  (loop for date from 13 to 19
        when (= (get-day-of-week date month year) day-num)
        return date))

(defun get-nth-week-day (month year day-num n)
  "Находит n-й (0-индексированный) день недели в месяце."
  (let ((count 0)
        (last-day (get-last-day-of-month month year)))
    (loop for date from 1 to last-day
          when (= (get-day-of-week date month year) day-num)
          do (if (= count n)
                 (return date)
                 (incf count)))))

(defun get-last-week-day (month year day-num)
  "Находит последний день недели в месяце."
  (let ((last-day (get-last-day-of-month month year)))
    (loop for date from last-day downto 1
          when (= (get-day-of-week date month year) day-num)
          return date)))

(defun get-last-day-of-month (month year)
  "Возвращает количество дней в месяце."
  (case month
    ((1 3 5 7 8 10 12) 31)
    ((4 6 9 11) 30)
    (2 (if (is-leap-year year) 29 28))))

(defun is-leap-year (year)
  "Проверяет, является ли год високосным."
  (or (and (= (mod year 4) 0) (not (= (mod year 100) 0)))
      (= (mod year 400) 0)))
