binary(Str, Dec):-
	
	% CONVERT STRING TO LIST OF CHARACTERS
	string_chars(Str, Chars),
	
	% GET RESULT FROM EACH CHAR FROM LIST
	bin_from_char_list(Chars, Dec).


% RETURN 0 WHEN LIST IS EMPTY
bin_from_char_list([], 0).


% JUST CONTINUE WHEN CHAR IS 0
bin_from_char_list(['0'|Tail], Result):-
	bin_from_char_list(Tail, Result),
	!.

	
% ADD 2 ^ VALUE WHEN CHAR IS 1
bin_from_char_list(['1'|Tail], Result):-
	
	% FIND POWER VALUE
	length(Tail, Pow),
	
	% FIND VALUE TO ADD TO RESULT
	Acc is 2 ^ Pow,
	
	% CONTINUE WITH TAIL
	bin_from_char_list(Tail, Cdr_result),
	
	% ADD THE RESULTS TOGETHER
	Result is Acc + Cdr_result.