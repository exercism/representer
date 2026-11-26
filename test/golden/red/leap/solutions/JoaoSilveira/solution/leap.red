Red [
	description: {"Leap" exercise solution for exercism platform}
	author: "João Pedro Silveira" ; you can write your name here, in quotes
]

leap: function [
	year
] [
	or~ and~ (year % 4 = 0) (year % 100 <> 0) (year % 400 = 0)
]

