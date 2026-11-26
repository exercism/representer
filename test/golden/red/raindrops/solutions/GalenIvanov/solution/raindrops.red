Red [
	description: {"Raindrops" exercise solution for exercism platform}
	author: "Galen Ivanov" 
]

convert: function [
	number
] [
    result: copy ""
	foreach factor [3 5 7] [
        if zero? number // factor [
            append result select [3 "Pling" 5 "Plang" 7 "Plong"] factor
        ]
    ]
    either empty? result [form number] [result]
]