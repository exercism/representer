sum_of_multiples(Factors, Limit, Sum) :-
  succ(L2, Limit),
  findall(
    N,
    (
      between(1, L2, N),
      once((member(F, Factors), 0 is N mod F))
    ),
    Numbers
  ),
  sumlist(Numbers, Sum).
