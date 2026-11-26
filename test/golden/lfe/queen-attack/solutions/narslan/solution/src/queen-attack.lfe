(defmodule queen-attack
  (export (create 2)
          (can-attack 2)))

; Please implement the exported function(s).

(defun create (column row)
  (if (andalso (>= column 0) (=< column 7) (>= row 0) (=< row 7))
    (list column row)
    'false))

(defun can-attack (queen1 queen2)
  (let* ((c1 (car queen1) )
	 (c2 (car queen2) )
	 (r1 (cadr queen1) )
	 (r2 (cadr queen2) ))
    (orelse
      (=:= c1 c2)
      (=:= r1 r2)
      (=:= (abs (- c1 c2)) (abs (- r1 r2))))))