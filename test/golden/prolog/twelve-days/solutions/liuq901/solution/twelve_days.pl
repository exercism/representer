recite(Verse, Lyrics) :-
    number(Verse, Number), thing(Things), 
    Prefix = ["On the ", Number, " day of Christmas my true love gave to me: "],
    atomic_list_concat(Prefix, PrefixAtom),
    length(Suffix, Verse), append(Suffix, _, Things), reverse(Suffix, Reversed),
    add_and(Reversed, Tmp), atomic_list_concat(Tmp, ", ", Atom),
    atomic_list_concat([PrefixAtom, Atom, "."], ResultAtom),
    atom_string(ResultAtom, ResultString), Lyrics = [ResultString], !.
recite(From, To, Lyrics) :-
    numlist(From, To, Range), maplist(recite, Range, Result),
    append(Result, Lyrics).

number(Idx, Number) :-
    Numbers = [
        "first", "second", "third", "fourth", "fifth", "sixth",
        "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth"
    ],
    nth1(Idx, Numbers, Number).

thing(Things) :-
    Things = [
        "a Partridge in a Pear Tree", "two Turtle Doves", "three French Hens",
        "four Calling Birds", "five Gold Rings", "six Geese-a-Laying",
        "seven Swans-a-Swimming", "eight Maids-a-Milking", "nine Ladies Dancing",
        "ten Lords-a-Leaping", "eleven Pipers Piping", "twelve Drummers Drumming"
    ].

add_and(Input, Result) :-
    length(Input, 1), Result = Input, !;
    append(Rest, [Last], Input),
    string_concat("and ", Last, Added),
    append(Rest, [Added], Result).
