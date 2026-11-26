# input: a floating point number
# output: the number rounded to two decimal places
def two_decimal: ((. * 100) | round) / 100;

# input: a planet as a string
# output: the number of seconds in a year on the input planet
def planet_year_duration:
  31557600 as $earth_year_seconds |
  if . | ascii_downcase == "earth" then $earth_year_seconds
  elif . | ascii_downcase == "mercury" then $earth_year_seconds * 0.2408467
  elif . | ascii_downcase == "venus" then $earth_year_seconds * 0.61519726
  elif . | ascii_downcase == "mars" then $earth_year_seconds * 1.8808158
  elif . | ascii_downcase == "jupiter" then $earth_year_seconds * 11.862615
  elif . | ascii_downcase == "saturn" then $earth_year_seconds * 29.447498
  elif . | ascii_downcase == "uranus" then $earth_year_seconds * 84.0168467
  elif . | ascii_downcase == "neptune" then $earth_year_seconds * 164.79132
  else error("Invalid planet: \(.)")
  end
;

try ((.seconds / (.planet | planet_year_duration)) | two_decimal) catch ("not a planet" | halt_error)