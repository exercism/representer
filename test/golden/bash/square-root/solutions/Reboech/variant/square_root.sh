#!/usr/bin/env bash

declare -i n="$1"

# Handle negative inputs as positive, but ensure that output is imaginary
if (( n<0 )); then
	(( n*=-1 ))
	suffix="i"
fi

# Set up initial xks for Newton's method
xk="$n"
prev=$((n+1))

while (( xk<prev )); do
	prev="$xk"
	(( xk=(xk+n/xk)/2 ))
done

# Check that the found x_k is indeed the solution (it might just be
# the square root rounded down)
if (( xk*xk==n )); then
	printf "%d%s\n" "$xk" "$suffix"
else
	printf "%d is not a tquare\n" "$1" >&2
	exit 1
fi

# MATHEMATICAL DETAILS
# The implementation uses an integer version of Newton's method to
# find the positive root of f(x)=x^2-n, where n is the input. Some
# information is given on
#   https://en.wikipedia.org/wiki/Integer_square_root
# but the argument that the iteration can stop once x_k>=x_{k-1} is
# pretty handwavy. Some more details are given below. Claim 1 shows
# that as long as we take our initial guess to be at least the square
# root, then our candidate solution decreases each time. Additionally,
# it ensures that if the true solution is found, then subsequent x_k's
# will be the true solution as well. Claim 2 ensures that we can only
# overshoot the true solution if sqrt(n) is non-integral. In this
# case, the next x_k will increase, terminating the algorithm.
#
# Claim 1: If x_k>=sqrt(n), then x_{k+1}<=x_k with equality for
# x_k=sqrt(n)
# We can rewrite x_{k+1} as floor(x_k/2 + n/(2x_k)). Using that
# x_k>=sqrt(n), it follows that
#   x_{k+1} <= floor(x_k/2 + sqrt(n)) <= floor(x_k) = x_k.
# This proves the inequality. For the equality, substitute x_k=sqrt(n)
# into the expression for x_{k+1}.
#
# Claim 2: If x_k>sqrt(n), then x_{k+1}>=floor(sqrt(n))
# To prove this, we show y_k>sqrt(n) where y_k is the value of x_k
# before rounding down. The result then follows by applying the floor
# function. From the way Newton's method works, this follows if the
# slope f'(x_k) of the tangent line through (x_k, f(x_k)) is greater
# than the slope
#   h = (x_k-sqrt(n))/(x_k^2-n)
# of the secant through (sqrt(n), 0) and (x_k, f(x_k)). By the mean
# value theorem, there is some c in the interval (sqrt(n), x_k)
# satisfying f'(c)=h. Since f'(x) is strictly increasing,
# h=f'(c)<f'(x_k), which shows y_k>sqrt(n).
