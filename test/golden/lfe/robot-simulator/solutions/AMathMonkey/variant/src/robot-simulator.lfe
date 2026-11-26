(defmodule robot-simulator
  (export (create 0)
          (place 3)
          (direction 1)
          (position 1)
          (left 1)
          (right 1)
          (advance 1)
          (control 2)

          ;; gen_server stuff
          (init 1)
          (handle_cast 2)
          (handle_call 3))
  (behaviour gen_server))

(defun create ()
  (tref (gen_server:start_link (MODULE) '() '()) 3))

(defun place (robot direction position)
  (gen_server:cast robot (tuple 'place direction position)))

(defun direction (robot)
  (gen_server:call robot 'direction))

(defun position (robot)
  (gen_server:call robot 'position))

(defun left (robot)
  (gen_server:cast robot 'left))

(defun do-left (dir)
  (case dir ('north 'west) ('west 'south) ('south 'east) ('east 'north)))

(defun right (robot)
  (gen_server:cast robot 'right))

(defun do-right (dir)
  (case dir ('north 'east) ('east 'south) ('south 'west) ('west 'north)))

(defun advance (robot)
  (gen_server:cast robot 'advance))

(defun do-advance ((dir (tuple x y))
  (case dir
    ('north (tuple x (+ y 1)))
    ('east (tuple (+ x 1) y))
    ('south (tuple x (- y 1)))
    ('west (tuple (- x 1) y)))))

(defun control (robot s)
  (gen_server:cast robot (tuple 'control s)))

(defun init (_)
  (tuple 'ok (tuple 'undefined (tuple 'undefined 'undefined))))

(defun handle_cast
  (((tuple 'place dir pos) _) (tuple 'noreply (tuple dir pos)))
  (('left (= state (tuple dir _)))
    (tuple 'noreply (tset state 1 (do-left dir))))
  (('right (= state (tuple dir _)))
    (tuple 'noreply (tset state 1 (do-right dir))))
  (('advance (tuple dir pos))
    (tuple 'noreply (tuple dir (do-advance dir pos))))
  (((tuple 'control s) state)
    (tuple 'noreply
      (lists:foldl
        (match-lambda ((c (= state (tuple dir pos)))
          (case c
            (#\L (tset state 1 (do-left dir)))
            (#\R (tset state 1 (do-right dir)))
            (#\A (tset state 2 (do-advance dir pos)))
            (_ state))))
        state
        s))))

(defun handle_call
  (('direction _ (= state (tuple dir _))) (tuple 'reply dir state))
  (('position _ (= state (tuple _ pos))) (tuple 'reply pos state)))
