def distance_to_center:
  hypot(.x; .y)
;

if distance_to_center <= 1 then 10
elif distance_to_center <= 5 then 5
elif distance_to_center <= 10 then 1
else 0
end
