(defmodule space-age
  (export (age-on 2)))

(defun earth-seconds ()
  31557600)

(defun orbital-period (planet)
  (case planet
    ('mercury 0.2408467)
    ('venus   0.61519726)
    ('earth   1.0)
    ('mars    2.8808158)
    ('jupiter 11.862615)
    ('saturn  29.447498)
    ('uranus  84.016846)
    ('neptune 164.79132)))


(defun age-on (planet seconds)
  (let* ((earth-year-seconds (earth-seconds))
         (period (orbital-period planet))
         (seconds-per-planet-year (* earth-year-seconds period))
         (planet-years (/ seconds seconds-per-planet-year)))
    planet-years))

