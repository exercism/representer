(defpackage :phone-number
  (:use :cl)
  (:export :clean))

(in-package :phone-number)

;; There are many ways to write a parser,
;; this is certainly one of the most long-winded
(defun clean (phrase)
  "Converts a PHRASE string into a string of digits.
Will evaluate to \"0000000000\" in case of an invalid input."
  (let ((result (make-array 10 :element-type 'base-char :fill-pointer 0))
        (pos 0)
        (collected 0))
    (labels
        ((fail (reason)
           (return-from clean
             (values (make-string 10 :initial-element #\0)
                     (format nil "~A~@[, looking at ‘~A’~], position ~A in “~A”"
                             reason
                             (when (< pos (length phrase)) (current-char))
                             pos phrase))))

         (in-string-p ()
           (< pos (length phrase)))

         (current-char ()
           (if (in-string-p)
               (char phrase pos)
               (fail "The string is too short")))

         (advance (&optional count-p)
           (incf pos)
           (when count-p (incf collected)))

         (maybe-skip (ch)
           (when (and (in-string-p)
                      (char= (current-char) ch))
             (advance) t))
             
         (skip-ws ()
           (loop
             with start = pos
             while (maybe-skip #\space)
             finally (return (> pos start))))

         ;; I allow either run of whitespace or only one of . or - inter groups
         ;; but do not force it to be the same separator all the time
         (skip-separator ()
           (and
            (skip-ws)
            (maybe-skip #\-)
            (maybe-skip #\.)))

         (validate (llim)
           (unless (and (digit-char-p (current-char))
                        (>= (char-code (current-char))
                            (char-code llim)))
             (fail "Wrong digit")))

         (collect (llim)
           (validate llim)
           (vector-push (current-char) result)
           (advance t))

         (skip-country ()
           (skip-ws)
           (maybe-skip #\+)
           (maybe-skip #\1))

         (collect-group (pattern &optional parens-allowed-p
                         &aux (open-paren-p nil))
           (skip-separator)
           (when parens-allowed-p (setf open-paren-p (maybe-skip #\()))
           (loop for l across pattern do (collect l))
           (when open-paren-p (or (maybe-skip #\)) (fail "Parens mismatch"))))

         (finalize ()
           (skip-ws)
           (if (and (= pos (length phrase))
                    (= collected 10))
               result
               (fail "The string is too long"))))

      ;; ... and finally
      (skip-country)
      (collect-group "200" t)
      (collect-group "200")
      (collect-group "0000")
      (finalize))))
