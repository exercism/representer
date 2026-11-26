Red [
	description: {"Secret Handshake" exercise solution for exercism platform}
	author: "João Pedro Silveira" ; you can write your name here, in quotes
]

commands: function [
	number
    /local actions
] [
	actions: copy []

    if not-equal? and~ number  1 0 [append actions "wink"]
    if not-equal? and~ number  2 0 [append actions "double blink"]
    if not-equal? and~ number  4 0 [append actions "close your eyes"]
    if not-equal? and~ number  8 0 [append actions "jump"]
    if not-equal? and~ number 16 0 [reverse actions]

    actions
]

