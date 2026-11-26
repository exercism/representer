possible_date(Month-Day):-
    member(Month-Day, 
        [may-15, may-16, may-19, 
        june-17, june-18, 
		july-14, july-16, 
        august-14, august-15, august+17]
	).

not_unique(Day):-
    findall(Month, possible_date(Month-Day), PossibleMonths),
    length(PossibleMonths, L), L > 1.

initial_state(Month, Day):-
    possible_date(Month-Day),
    findall(D1, possible_date(Month-D1), PossibleDays),
	forall(member(D2, PossibleDays), not_unique(D2)). 

bernard_knows(Month, Day):-
    initial_state(Month, Day),
	findall(M, initial_state(M, Day), [Month]).

albert_knows(Month, Day):-
    bernard_knows(Month, Day),
	findall(D, bernard_knows(Month, D), [Day]).

cheryls_birthday(Month, Day):-
	albert_knows(Month, Day).  