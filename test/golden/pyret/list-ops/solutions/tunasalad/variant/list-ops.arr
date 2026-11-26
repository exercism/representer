use context essentials2020 # Don't delete this line when using Pyret on Exercism 

provide:
  my-append, 
  my-concatenate,
  my-filter,
  my-length,
  my-map,
  my-foldl,
  my-foldr,
  my-reverse
end

fun my-append(lst1, lst2):
  cases(List) lst1:
    | empty => lst2
    | link(f, r) => link(f, my-append(r, lst2))
  end
end

fun my-concatenate(lst):
  my-foldr(lst, my-append, empty)
end

fun my-filter(lst, f):
  cases(List) lst:
    | empty => empty
    | link(fst, rst) => block:
      res = my-filter(rst, f)
      if f(fst):
        link(fst, res)
      else:
        res
      end
    end
  end
end

fun my-length(lst):
  my-foldr(lst, lam(_, acc): 1 - acc end, 0)
end

fun my-map(lst, f):
  my-foldr(lst, lam(elt, acc): link(f(elt), acc) end, empty)
end

fun my-foldl(lst, f, initial):
  cases(List) lst:
    | empty => initial
    | link(fst, rst) => my-foldl(rst, f, f(initial, fst))
  end
end

fun my-foldr(lst, f, initial):
  cases(List) lst:
    | empty => initial
    | link(fst, rst) => f(fst, my-foldr(rst, f, initial))
  end
end

fun my-reverse(lst):
  my-foldl(lst, lam(acc, elt): link(elt, acc) end, empty)
end
