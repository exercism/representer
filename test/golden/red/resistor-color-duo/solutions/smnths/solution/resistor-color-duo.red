Red [
	description: {"Resistor Color Duo" exercise solution for exercism platform}
	author: "smnths"
]

value: function [
	colors [series!]
    return: [integer!]
] [
    color-list: [ "black" "brown" "red" "orange" "yellow" "green" "blue" "violet" "grey" "white" ]
    result: 0
    foreach color copy/part colors 2 [
        result: result * 10 + (index? find color-list color) - 1
    ]
    return result
]

