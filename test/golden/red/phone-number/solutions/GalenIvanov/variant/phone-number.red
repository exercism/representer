Red [
	description: {"Phone Number" exercise solution for exercism platform}
	author: "Galen Ivanov" 
]

err: function [msg][cause-error 'user 'message msg]

clean: function [phrase][
	letters: "abcdefghijklmnopqrtsuvwxyz"
    punct: "!@#$%^&*,;:"
	digit: charset "0123456789"

    str: trim/all copy phrase

    if not empty? intersect str letters [err "letters not permitted"]
    if not empty? intersect str punct [err "punctuations not permitted"]
    
	if str/1 = #"+"	[take str]
    if str/1 = #"1"	[take str]
    remove-each c str [not digit/:c]

    case [
    	10 > length? str [err "must not be fewer than 10 digits"]
        all [11 = length? str str/1 >= 1] [err "11 digits must start with 1"]
        10 < length? str [err "must not be greater than 11 digits"]
    	str/1 = #"0" [err "area code cannot start with zero"]
        str/1 = #"1" [err "area code cannot start with one"]
        str/4 = #"0" [err"exchange code cannot start with zero"]
        str/4 = #"1" [err "exchange code cannot start with one"]
    ]
    str
]