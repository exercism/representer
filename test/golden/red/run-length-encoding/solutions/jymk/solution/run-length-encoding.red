Red [
	description: {"Run Length Encoding" exercise solution for exercism platform}
	author: "" ; you can write your name here, in quotes
]

encode: function [
	string
] [
    len: length? string
    if len = 1 [
        return string
    ]
    res: ""
    cnt: 0
    i: 1
	while [i < len][
        c: string/:i
        c1: pick string i + 1
        if all [c = c1 i = (len - 1)] [
            append/only res to-string (cnt + 2)
            append res c
            break
        ]
        if c <> c1 [
            either cnt = 0 [
                append res c
            ][
                append/only res to-string (cnt + 1)
                append res c
            ]
			if i = (len - 1) [
                append res c1
                break
            ]
            cnt: 0
            i: i + 1
            continue
        ]
        cnt: cnt + 1
        i: i + 1
    ]
    res
]

decode: function [
	string
] [
    res: ""
    n: 0
    foreach c string[
        either all [c >= #"0" c <= #"9"][
            n: 10 * n + to-integer (c - #"0")
            print n
        ][
            if n = 0 [n: 1]
            append/dup res c n
            n: 0
        ]
    ]
    res
]
