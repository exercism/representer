;;; parallel-letter-frequency.el --- Parallel Letter Frequency (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'cl-lib)

(defconst *num-of-processes* (num-processors))

(defun calculate-frequencies (texts)
  (let ((table (make-hash-table :test #'eq))
        (n-procs *num-of-processes*)
        (procs (make-vector *num-of-processes* nil)))
    (dotimes (i *num-of-processes*)
      (setf (aref procs i)
            (make-process
             :name "char-count"
             :buffer nil
             :command '("emacs" "-Q" "-batch" "-l" "count-chars-from-stdin.el"
                        "-f" "count-chars-from-stdin" "2>/dev/null")
             :connection-type 'pipe
             :filter
             (lambda (proc expr)
               (let ((sub-table (car (read-from-string expr))))
                 (maphash (lambda (char count)
                            (setf (gethash char table)
                                  (+ (gethash char table 0) count)))
                          sub-table)))
             :sentinel
             (lambda (proc event)
               (cl-decf n-procs)
               (when (not (string= event "finished\n"))
                 (error "%s" event)))
             :noquery t))
      (when (not (process-live-p (aref procs i)))
          (error "failed to start a subprocess")))
    (let ((i 0))
      (dolist (line texts)
        (process-send-string (aref procs i) line))
      (setf i (mod (1+ i) *num-of-processes*)))
    (dotimes (i *num-of-processes*)
      (process-send-eof (aref procs i)))
    (while (> n-procs 0)
      (sleep-for 0.1))
    table))

(provide 'parallel-letter-frequency)


