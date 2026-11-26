(defpackage :rail-fence-cipher
  (:use :cl)
  (:export :encode
           :decode))

(in-package :rail-fence-cipher)

(defun loop-back (items)
  "Modifies the last cdr of list ITEMS, returning a circular list"
  (setf (cdr (last items)) items))

(defun cycle (n len)
  "Returns a list of LEN numbers.  The numbers in the returned list
are of the form (1...N,N-1,N-2,...2) repeated to create a list
of length LEN)"
  ;; 1. Create two lists of integers; one of numbers from 1 to N
  ;;    one for numbers from (N - 1) down to 2.
  ;; 2. Append the two lists, giving a list of integers.
  ;; 3. Convert the list of integers to a circular list
  ;; 4. Iterate through the circular list (up to LEN) creating
  ;;    a list to create a list of LEN numbers.
  (let* ((b (append (loop for i from 1 to n collect i)
                    (loop for i from (1- n) downto 2 collect i)))
         (base (loop-back b)))
    (loop for i from 0 to len collect (nth i base))))

(defun make-pairs (lx n)
  "Returns a reordering of LX.  The elements of LX are reordered
using a rail fence cipher of N rails."
  ;; 1. Generate the list of positions for the characters in LX
  ;; 2. Create a list of pairs: (X . position).
  ;; 3. Sort the list by position.
  (mapcar #'first
          (sort (mapcar #'cons lx (cycle N (length lx)))
                #'< :key #'cdr)))

(defun encode (msg rails)
  ;; 1. Remove any blanks or puncuation characters from the string.
  ;; 2. Coerce the string to a list of characters.
  ;; 3. Encode the list of chars
  ;; 4. Coerce the list to a string.
  (let* ((m (coerce (remove-if-not #'alphanumericp msg) 'list))
         (ms (make-pairs m rails)))
    (coerce ms 'string)))

(defun decode (msg rails)
  ;; 1. Create a list of integers from 1 to the length of the
  ;;    message.
  ;; 2. Encode the list of integers to match the position of
  ;;    the integers on a rail fence.
  ;; 3. Create a list of pairs consisting of the letters of the
  ;;    encoded message paired with the list of integers.
  ;; 4. Sort the list of pairs by position.
  ;; 5. Convert the sorted list to a string.
  (coerce
   (mapcar #'first
      (sort
        (mapcar #'cons
           (coerce msg 'list)
           (make-pairs (loop for i from 1 to (length msg) collect i)
                        rails)) #'< :key #'cdr)) 'string))
