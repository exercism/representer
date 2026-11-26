def is_leap y = let l m = y%m==0 in l 4 && !l 100 || l 400
