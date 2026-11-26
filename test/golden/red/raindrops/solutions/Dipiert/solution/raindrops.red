Red [
	description: {"Raindrops" exercise solution for exercism platform}
	author: "Dipiert"
]

convert: function [
	number
] [
    result: ""
    if number % 3 = 0  [result: append result "Pling"]
    if number % 5 = 0  [result: append result "Plang"]
    if number % 7 = 0  [result: append result "Plong"]
    either empty? result [to-string number] [result]	
]
