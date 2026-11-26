Red [
	description: {"Scrabble Score" exercise solution for exercism platform}
	author: "factor3"
]

letter-value: function [letter][
    switch letter [
        #"A" #"E" #"I" #"O" #"U" #"L" #"N" #"R" #"S" #"T" [1]
        #"D" #"G" [2]
        #"B" #"C" #"M" #"P" [3]
        #"F" #"H" #"V" #"W" #"Y" [4]
        #"K" [5]
        #"J" #"X" [8]
        #"Q" #"Z" [10]
    ]
]

score: function [word][
	sum: 0
	foreach letter word [
		sum: sum + letter-value uppercase letter
    ]
	sum
]