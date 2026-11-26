leap(Y) :-
	0 is Y mod 400, !;
	0 is Y mod 4,
	not(0 is Y mod 100).