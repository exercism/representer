% proverb(+Items, -Lines)
% Generates the proverb lines for a list of Items
proverb([], []).
proverb([_], [FinalLine]) :-
    % Only one item, the final line references it
    [First|_] = [_],
    format(string(FinalLine), 'And all for the want of a ~w.', [First]).
proverb(Items, Lines) :-
    Items = [First|_],
    proverb_lines(Items, First, Lines).

% Generate main proverb lines and final line
proverb_lines([_], First, [FinalLine]) :-
    % Reached last item, output final line
    format(string(FinalLine), 'And all for the want of a ~w.', [First]).
proverb_lines([A,B|Rest], First, [Line|Lines]) :-
    format(string(Line), 'For want of a ~w the ~w was lost.', [A,B]),
    proverb_lines([B|Rest], First, Lines).
