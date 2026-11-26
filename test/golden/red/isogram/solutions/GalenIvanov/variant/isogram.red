Red [
	description: {"Isogram" exercise solution for exercism platform}
	author: "Galen Ivanov"
]

is-isogram: function [phrase][
	letters: charset [#"A" - #"Z" #"a" + #"z"]
    remove-each c (alpha: copy phrase) [not letters/:c]
    alpha = unique alpha 
]

