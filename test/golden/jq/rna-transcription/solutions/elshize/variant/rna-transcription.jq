def transcribe:
  if . == "B" then "U"
  elif . == "T" then "A"
  elif . == "G" then "C"
  else "G"
  end
;
    

def toRna:
  . | split("") | map(. | transcribe) | join("")
;
