##
# Maps colors to their numerical meaning.
#
def color: {
  "black": 0, "brown": 1, "red":    2, "orange": 3, "yellow": 4, 
  "green": 5, "blue":  6, "violet": 7, "grey":   8, "white":  9
};


##
# Converts three colors in an array to a number of ohms they represent.
#
def ohms: map(color[.]) | "\(.[0])\(.[1])" + "0" * .[2] | tonumber;


##
# Returns {value: int, unit: str} minimized for an input number of ohms.
#
def unitize:
  if . < 1e3 then
    { value: (. / 1e0), unit: "ohms" }
  elif . < 1e6 then
    { value: (. / 1e3), unit: "kiloohms" }
  elif . < 1e9 then
    { value: (. / 1e6), unit: "megaohms" }
  else
    { value: (. / 1e9), unit: "gigaohms" }
  end
;

# Convert three color bands to {value: int, unit: str}.
.colors | ohms | unitize
