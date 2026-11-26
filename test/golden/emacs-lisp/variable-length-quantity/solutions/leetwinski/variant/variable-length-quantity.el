;;; variable-length-quantity.el --- Variable Length Quantity (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(defconst sept #b1111111)
(defconst i128 #b10000000)

(cl-defmacro updf (place f) `(setf ,place (funcall ,f ,place)))

(defun lastp (x) (zerop (logand i128 x)))
(defun flipflag (x) (logxor x i128))
(defun resetflag (x) (logand (flipflag x) x))

(defun enc-num (n)
  (if (zerop n) 
    (list 0)
    (cl-loop for off below 32 by 7
             for v = (logand (ash n (- off)) sept)
             collect v into res
             finally (let ((res (mapcar
                                 #'flipflag
                                 (cl-member-if-not #'zerop (nreverse res)))))
                       (updf (car (last res)) #'flipflag)
                       (cl-return res)))))

(cl-defun nums (data &aux (res (list nil)))
  (cl-loop for x in data
           do (push x (car res))
           when (lastp x) do (push nil res)
           finally (if (car res)
                       (error "invalid input")
                     (cl-return (nreverse (mapcar #'nreverse (cdr res)))))))

(cl-defun dec-num (n &aux (res 0))
  (cl-loop for off from 0 by 8
           for x in (reverse (mapcar #'resetflag n))
           do (setf res (logior res (ash x off)))
           finally (return res)))

(defun decode (ns) (mapcar #'dec-num (nums ns)))
(defun encode (ns) (mapcan #'enc-num ns))

(provide 'variable-length-quantity)
;;; variable-length-quantity.el ends here

