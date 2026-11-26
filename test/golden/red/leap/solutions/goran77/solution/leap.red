Red [
	description: {"Leap" exercise solution for exercism platform}
	author: "goran77" ; you can write your name here, in quotes
]

leap: function [year] [
	to-logic case [
    				((modulo year 400) = 0) [true]
       			    ((modulo year 4) = 0) and ((modulo year 100) <> 0) [true]
   			      ] 
    ]

