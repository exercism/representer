% Main predicate: counts nucleotides in a DNA sequence
nucleotide_count(DNA, Counts) :-
    string_chars(DNA, Chars),            
    valid_dna(Chars),                     
    count_each(Chars, Counts).           

% Validate the DNA sequence
valid_dna([]).
valid_dna([H|T]) :-
    member(H, ['A', 'C', 'G', 'T']),      
    valid_dna(T).                        

% Count occurrences of each nucleotide
count_each(Chars, Counts) :-
    count_char(Chars, 'A', ACount),      
    count_char(Chars, 'C', CCount),       
    count_char(Chars, 'G', GCount),      
    count_char(Chars, 'T', TCount),      
    Counts = ['A'-ACount, 'C'-CCount, 'G'-GCount, 'T'-TCount]. 

% Helper predicate to count occurrences of a character in a list
count_char([], _, 0).
count_char([H|T], Char, Count) :-
    count_char(T, Char, RestCount),
    (H == Char -> Count is RestCount + 1; Count = RestCount).

% Example tests
:- begin_tests(nucleotide_counting).

% Test for an empty DNA strand
test(empty_dna_strand_has_no_adenosine) :-
    nucleotide_count("", Counts),
    member('A'-0, Counts),
    member('C'-0, Counts),
    member('G'-0, Counts),
    member('T'-0, Counts).

% Test repetitive sequences
test(repetitive_cytidine_gets_counted) :-
    nucleotide_count("CCCC", Counts),
    member('C'+4, Counts).

% Test for counting thymidine
test(counts_only_thymidine) :-
    nucleotide_count("TTT", Counts),
    member('T'-3, Counts).

% Test for valid DNA sequence
test(valid_sequence) :-
    nucleotide_count("GATTACA", Counts),
    member('A'-3, Counts),
    member('C'-1, Counts),
    member('G'-1, Counts),
    member('T'-2, Counts).

% Test for invalid DNA sequence
test(fails_when_not_dns, [fail]) :-
    nucleotide_count("INVALID", _).

:- end_tests(nucleotide_counting).