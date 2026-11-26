#!/usr/bin/env bash

# raindrops.sh : a simple exercise similar to FizzBuzz

# Function to test if $1 is evenly divisible by $2
divisibleBy () {
	(( $1 % $2 == 0 ))
}

# The first argument.
number=$1

# Initialize empty variable to hold the answer string.
answer=

# If $number is divisible by 3, then add "Pling" to $answer
if divisibleBy "$number" 3; then
	answer+="Pling"
fi

# If $number is divisible by 5, then add "Plang" to $answer
if divisibleBy "$number" 5; then
	answer+="Plang"
fi

# If $number is divisible by 7, then add "Plong" to $answer
if divisibleBy "$number" 7; then
	answer+="Plong"
fi

# If $answer is still empty, assign $number to it.
if [[ "$answer" ==  "" ]]; then
	answer="$number"
fi

echo "$answer"
