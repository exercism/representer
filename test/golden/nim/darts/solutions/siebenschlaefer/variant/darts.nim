## This module solves Exercism's darts exercise.

from math import hypot

const Circles = [
  (radius: 1.0, points: 10),
  (radius: 5.0, points: 5),
  (radius: 10.0, points: 1),
]

proc score*(x, y: float): int =
  ## Calculates the points earned from a dart toss.
  let distance = hypot(x, y)
  for (radius, points) in Circles:
    if distance < radius:
      return points
  return 0
