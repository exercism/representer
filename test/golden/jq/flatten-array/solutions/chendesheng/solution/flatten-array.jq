def my_flatten:
  reduce .[] as $item ([]; 
                       if ($item | type) == "array" then
                         . + ($item | my_flatten)
                       elif $item then
                         . + [$item]
                       else
                         .
                       end)
;

my_flatten
