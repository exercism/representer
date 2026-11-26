% Define the colors
color(red).
color(green).
color(ivory).
color(yellow).
color(blue).

% Define the nationalities
nationality(english).
nationality(spanish).
nationality(ukrainian).
nationality(norwegian).
nationality(japanese).

% Define the pets
pet(dog).
pet(snails).
pet(fox).
pet(horse).
pet(zebra).

% Define the drinks
drink(coffee).
drink(tea).
drink(milk).
drink(orange_juice).
drink(water).

% Define the cigarettes
cigarettes(old_gold).
cigarettes(kools).
cigarettes(chesterfields).
cigarettes(lucky_strike).
cigarettes(parliaments).

% Define the houses and their attributes
house(House) :-
    color(HouseColor),
    nationality(HouseNationality),
    pet(HousePet),
    drink(HouseDrink),
    cigarettes(HouseCigarettes),
    House = [HouseColor, HouseNationality, HousePet, HouseDrink, HouseCigarettes].

% Helper predicate to get the element at a specific index in a list
nth_element(1, [X|_], X).
nth_element(N, [_|T], X) :- N > 1, N1 is N-1, nth_element(N1, T, X).

% Define the rules for the puzzle
rules(Houses) :-
    % Define the list of houses
    length(Houses, 5),
    % The Englishman lives in the red house
    member([red, english, _, _, _], Houses),
    % The Spaniard owns the dog
    member([_, spanish, dog, _, _], Houses),
    % Coffee is drunk in the green house
    member([green, _, _, coffee, _], Houses),
    % The Ukrainian drinks tea
    member([_, ukrainian, _, tea, _], Houses),
    % The green house is immediately to the right of the ivory house
    nth_element(1, Houses, [ivory, _, _, _, _]),
    nth_element(2, Houses, [green, _, _, _, _]),
    % The Old Gold smoker owns snails
    member([_, _, snails, _, old_gold], Houses),
    % Kools are smoked in the yellow house
    member([yellow, _, _, _, kools], Houses),
    % Milk is drunk in the middle house
    member([_, _, _, milk, _], Houses),
    % The Norwegian lives in the first house
    member([_, norwegian, _, _, _], Houses),
    % The man who smokes Chesterfields lives in the house next to the man with the fox
    next_to([_, _, _, _, chesterfields], [_, _, fox, _, _], Houses),
    % Kools are smoked in the house next to the house where the horse is kept
    next_to([_, _, _, _, kools], [_, _, horse, _, _], Houses),
    % The Lucky Strike smoker drinks orange juice
    member([_, _, _, orange_juice, lucky_strike], Houses),
    % The Japanese smokes Parliaments
    member([_, japanese, _, _, parliaments], Houses),
    % The Norwegian lives next to the blue house
    next_to([_, norwegian, _, _, _], [blue, _, _, _, _], Houses).

% Helper predicate to determine if two houses are adjacent
next_to(X, Y, Houses) :- append(_, [X, Y|_], Houses).
next_to(X, Y, Houses) :- append(_, [Y, X|_], Houses).

zebra_owner(Owner) :-
    % Apply the rules to filter the solutions
    rules(Houses),
    % Find the house where the zebra is owned
    member([_, Owner, zebra, _, _], Houses).

water_drinker(Drinker) :-
    % Apply the rules to filter the solutions
    rules(Houses),
    % Find the house where water is drunk
    member([_, Drinker, _, water, _], Houses).
