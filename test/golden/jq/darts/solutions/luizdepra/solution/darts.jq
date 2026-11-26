((pow(.x; 2) + pow(.y; 2)) | sqrt) as $distance
| if $distance <= 1 then 10
  elif $distance <= 5 then 5
  elif $distance <= 10 then 1
  else 0 
  end
