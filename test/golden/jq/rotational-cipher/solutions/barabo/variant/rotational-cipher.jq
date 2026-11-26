# Rotates a character among A..Z or a..z by $n.
def rot(n; a):
  if a <= . and . <= (a - 26) then
    a + (. - a + n) % 26
  end;

# Apply a filter to exploded characters of a string.
def apply(fn): explode | map(fn) | implode;

# Rotate all alpha characters, leaving others in place.
.shiftKey as $n | .text | apply(rot($n; 97) | rot($n; 65))
