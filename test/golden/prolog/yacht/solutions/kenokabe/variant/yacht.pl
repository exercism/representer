:- module(yacht, [score/3]).

% Yacht scoring predicates

score(Dice, Category, Score) :-
    score_category(Category, Dice, Score).

% Number categories: count and multiply by face value
score_category(ones, Dice, Score) :- score_number(1, Dice, Score).
score_category(twos, Dice, Score) :- score_number(2, Dice, Score).
score_category(threes, Dice, Score) :- score_number(3, Dice, Score).
score_category(fours, Dice, Score) :- score_number(4, Dice, Score).
score_category(fives, Dice, Score) :- score_number(5, Dice, Score).
score_category(sixes, Dice, Score) :- score_number(6, Dice, Score).

% Full House: three of one number and two of another
score_category(full_house, Dice, Score) :-
    msort(Dice, Sorted),
    ( is_full_house(Sorted) -> sum_list(Dice, Score) ; Score = 0 ).

% Four of a Kind: at least four dice showing the same face
score_category(four_of_a_kind, Dice, Score) :-
    msort(Dice, Sorted),
    ( has_four_of_kind(Sorted, Value) -> Score is Value / 4 ; Score = 0 ).

% Little Straight: 1-2-3-4-5
score_category(little_straight, Dice, Score) :-
    ( msort(Dice, [1, 2, 3, 4, 5]) -> Score = 30 ; Score = 0 ).

% Big Straight: 2-3-4-5-6
score_category(big_straight, Dice, Score) :-
    ( msort(Dice, [2, 3, 4, 5, 6]) -> Score = 30 ; Score = 0 ).

% Choice: sum of all dice
score_category(choice, Dice, Score) :-
    sum_list(Dice, Score).

% Yacht: all five dice showing the same face
score_category(yacht, [D, D, D, D, D], 50).
score_category(yacht, _, 0).

% Helper: score for number categories
score_number(Value, Dice, Score) :-
    include(=(Value), Dice, Matches),
    length(Matches, Count),
    Score is Value * Count.

% Helper: check if sorted dice form a full house
is_full_house([A, A, A, B, B]) :- A \= B.
is_full_house([A, A, B, B, B]) :- A \= B.

% Helper: check if sorted dice have four of a kind
has_four_of_kind([A, A, A, A, _], A).
has_four_of_kind([_, A, A, A, A], A).
