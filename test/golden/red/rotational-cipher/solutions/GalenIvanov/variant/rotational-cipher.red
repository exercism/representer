Red [
	description: {"Rotational Cipher" exercise solution for exercism platform}
	author: "Galen Ivanov"
]

rotate: function [
	text
	shiftKey
] [
    up:    charset [#"A" - #"Z"]
    lower: charset [#"a" - #"z"]	
    parse text [
        any [
            change set w up    (#"A" - (w - #"A" + shiftKey % 26))
          | change set w lower (#"a" + (w - #"a" + shiftKey % 26))
          | skip]
    ]
    text
]

