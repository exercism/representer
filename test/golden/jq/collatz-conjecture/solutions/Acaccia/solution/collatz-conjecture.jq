def steps:
  def step_rec:
    if . == 1 then 0
    else 1 + (if . % 2 == 0 then . / 2 else . * 3 + 1 end | step_rec)
  end;
  
  if . < 1 
    then "Only positive integers are allowed" | halt_error
    else step_rec
  end;