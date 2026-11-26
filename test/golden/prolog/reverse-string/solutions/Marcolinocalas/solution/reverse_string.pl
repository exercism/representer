
string_reverse(Input, Output) :-
    string_chars(Input, Chars),      % Convert string -> list of chars
    reverse(Chars, RevChars),        % Reverse the list
    string_chars(Output, RevChars).  % Convert back -> string
    