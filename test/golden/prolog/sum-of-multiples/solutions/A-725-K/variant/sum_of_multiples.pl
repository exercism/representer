%% to debug long lists
%% :- set_prolog_flag(answer_write_options, [max_depth(0)]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% --- AUXILIARY PROCEDURES --- %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% this predicate sum the multiples of a single number up to limit
%% using accumulator parameter
create_mult(N, Limit, Acc, L) :-
	create_mult(N, Limit, 1, Acc, L).

%% auxiliary predicate to calculcate create_mult/3
create_mult(N, Limit, Mult, Acc, L) :-
	NN is Mult*N,
	Limit >= NN, !,
	(
		\+ member(NN, Acc) ->
			append(Acc, [NN], Acc1);
			Acc1 = Acc
	),
	M1 is Mult + 1,
	create_mult(N, Limit, M1, Acc1, L), !.
create_mult(_, _, _, L, L).

%% ------------------------------------------------------------

%% this predicate calculate the sum of all elements in a list
my_sum_list([], 0).
my_sum_list([H|T], S) :-
	my_sum_list(T, Sum),
	S is Sum+H.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% --- MAIN PROCEDURES --- %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% sum of all multiples
sum_of_multiples(L, Limit, Sum) :-
	sum_of_multiples(L, Limit, [], Sum).

%% auxiliary predicate to calculcate sum_of_multiples/3
sum_of_multiples([FF|Factors], Limit, Acc, Sum) :-
	create_mult(FF, Limit, Acc, Temp),
	sum_of_multiples(Factors, Limit, Temp, Sum).
sum_of_multiples([], _, Acc, Sum) :-
	my_sum_list(Acc, Sum).
