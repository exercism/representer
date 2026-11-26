(defpackage :rail-fence-cipher
  (:use :cl)
  (:export :encode
           :decode))

(in-package :rail-fence-cipher)

(defun rail-iterator (rail-number total-rails)
  (let ((step (* 2 (1- total-rails))))
    (if (or (zerop rail-number)
            (= rail-number (1- total-rails)))
        ;; The first and the last rail receive letters only once per cycle.
        (let ((pos rail-number))
          (lambda () (prog1 pos (incf pos step))))
        ;; But the other tracks – twice
        (let ((forward rail-number)
              (backward (- step rail-number)))
          (lambda ()
            (if (< forward backward)
                (prog1 forward (incf forward step))
                (prog1 backward (incf backward step))))))))


(defun encode (msg rails)
  (let ((ciphertext (make-array (length msg) :element-type 'character :fill-pointer 0)))
    (dotimes (r rails (coerce ciphertext 'simple-string))
      (loop with i = (rail-iterator r rails)
            for pos = (funcall i)
            while (<= pos (length msg))
            do (vector-push (char msg pos) ciphertext)))))

(defun decode (msg rails)
  (loop with cpos = 0
        with plaintext
          = (make-array (length msg) :element-type 'character)
        for r below rails
        do
           (loop with i = (rail-iterator r rails)
                 for ppos = (funcall i)
                 while (< ppos (length msg))
                 do (setf (char plaintext ppos)
                          (char msg (prog1 cpos (incf cpos)))))
        finally (return (coerce plaintext 'simple-string))))
