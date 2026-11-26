drop(N, D, Sound, Sounds) :-
	(N mod D =:= 0 -> Sounds = Sound ; Sounds = "").

pling(N, Sounds) :-
	drop(N, 3, "Pling", Sounds).

plang(N, Sounds) :-
	drop(N, 5, "Plang", Sounds).

plong(N, Sounds) :-
	drop(N, 7, "Plong", Sounds).

convert(N, Sounds) :-
	pling(N, Pling),
	plang(N, Plang),
	plong(N, Plong),
	string_concat(Pling, Plang, PlingPlang),
	string_concat(PlingPlang, Plong, PlingPlangPlong),
	(PlingPlangPlong = "" -> number_string(N, Sounds) ; Sounds = PlingPlangPlong).
