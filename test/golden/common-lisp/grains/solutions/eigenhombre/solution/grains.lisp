(defpackage :grains
  (:use :cl)
  (:export :square :total))
(in-package :grains)

(defun square (n)
  (declare (fixnum n))
  (ash 1 (1- n)))

(with-output-to-string (*standard-output*)
  (disassemble 'square))
;;=>
'"; disassembly for SQUARE
; Size: 52 bytes. Origin: #x700EE8FDE0                        ; SQUARE
; DE0:       AC0A40F9         LDR R2, [THREAD, #16]           ; binding-stack-pointer
; DE4:       4C0B00F9         STR R2, [CFP, #16]
; DE8:       200400D1         SUB NL0, NL1, #1
; DEC:       4A0080D2         MOVZ R0, #2
; DF0:       0B0000AB         ADDS R1, NL0, NL0
; DF4:       47000054         BVC L0
; DF8:       CBFCFF58         LDR R1, #x700EE8FD90            ; -4611686018427387905
; DFC: L0:   76FCFF58         LDR LEXENV, #x700EE8FD88        ; #<SB-KERNEL:FDEFN ASH>
; E00:       970080D2         MOVZ NARGS, #4
; E04:       DE9240F8         LDR LR, [LEXENV, #9]
; E08:       DE130091         ADD LR, LR, #4
; E0C:       C0031FD6         BR LR
; E10:       E00120D4         BRK #15                         ; Invalid argument count trap
"

(defun base-total ()
  (loop for n from 1 to 64
        summing (square n) into sum
        finally (return sum)))

(defun inline-total ()
  (declare (inline square))
  (loop for n from 1 to 64
        summing (square n) into sum
        finally (return sum)))

(defmacro comment (&rest body) (declare (ignore body)))

(defun total-using-do ()
  (do ((n 1 (1+ n))
       (sum 0 (+ sum (square n))))
      ((> n 64) sum)))

(macroexpand-1 '(do ((n 1 (1+ n))
                     (sum 0 (+ sum (square n))))
                 ((> n 64) sum)))
;;=>
(comment
 (BLOCK NIL
   (LET ((N 1) (SUM 0))
     (DECLARE (IGNORABLE N SUM))
     (TAGBODY
        (GO #:G777)
        #:G776
        (TAGBODY)
        (PSETQ N (1+ N)
               SUM (+ SUM (SQUARE N)))
        #:G777
        (UNLESS (> N 64) (GO #:G776))
        (RETURN-FROM NIL (PROGN SUM))))))

(defun total-using-tweaked-macroexpand-of-do ()
  (let ((n 1) (sum 0))
    (declare (ignorable n sum))
    (tagbody
       (go g1)
     g2
       (psetq n (1+ n)
              sum (+ sum (square n)))
     g1
       (unless (> n 64) (go g2))
       (return-from total-using-tweaked-macroexpand-of-do sum))))

(defun total-using-tweaked-macroexpand-of-do-and-inline-square ()
  (let ((n 1) (sum 0))
    (declare (ignorable n sum)
             (inline square))
    (tagbody
       (go g1)
     g2
       (psetq n (1+ n)
              sum (+ sum (square n)))
     g1
       (unless (> n 64) (go g2))
       (return-from total-using-tweaked-macroexpand-of-do-and-inline-square sum))))

(defmacro bench (f)
  (let ((i (gensym)))
    `(list
      (format nil "Benchmark: ~a~%" (quote ,f))
      (with-output-to-string (*trace-output*)
        (time
         (dotimes (,i (* 3 1000 1000))
           (funcall (function ,f))))))))

(comment
 (list
  (bench inline-total)
  (bench total-using-tweaked-macroexpand-of-do-and-inline-square)
  (bench base-total)
  (bench total-using-do)
  (bench total-using-tweaked-macroexpand-of-do))
 ;;=>
 '(("Benchmark: INLINE-TOTAL
"
    "Evaluation took:
  1.411 seconds of real time
  1.413301 seconds of total run time (1.365802 user, 0.047499 system)
  [ Run times consist of 0.009 seconds GC time, and 1.405 seconds non-GC time. ]
  100.14% CPU
  384,040,928 bytes consed

")
   ("Benchmark: TOTAL-USING-TWEAKED-MACROEXPAND-OF-DO-AND-INLINE-SQUARE
"
    "Evaluation took:
  1.423 seconds of real time
  1.424874 seconds of total run time (1.378546 user, 0.046328 system)
  [ Run times consist of 0.007 seconds GC time, and 1.418 seconds non-GC time. ]
  100.14% CPU
  384,040,944 bytes consed

")
   ("Benchmark: BASE-TOTAL
"
    "Evaluation took:
  1.938 seconds of real time
  1.938959 seconds of total run time (1.892394 user, 0.046565 system)
  100.05% CPU
  383,975,424 bytes consed

")
   ("Benchmark: TOTAL-USING-DO
"
    "Evaluation took:
  1.944 seconds of real time
  1.945864 seconds of total run time (1.898179 user, 0.047685 system)
  [ Run times consist of 0.008 seconds GC time, and 1.938 seconds non-GC time. ]
  100.10% CPU
  383,975,408 bytes consed

")
   ("Benchmark: TOTAL-USING-TWEAKED-MACROEXPAND-OF-DO
"
    "Evaluation took:
  1.943 seconds of real time
  1.944547 seconds of total run time (1.897072 user, 0.047475 system)
  [ Run times consist of 0.007 seconds GC time, and 1.938 seconds non-GC time. ]
  100.10% CPU
  383,975,392 bytes consed

")))

;; Use the fastest one:
(setf (fdefinition 'total) #'inline-total)
