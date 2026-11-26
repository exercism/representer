def build_sieve:
	# Create an array for each number upto and including limit
	# 0 & 1 are included so each number sits at the correct index.
	# Both are explicitly marked as non-prime.
 	[range(. + 1)] | map(true) | .[0] = false | .[1] = false
;

def mark_composites(i):
	if .[i] then
		# The field in the array is only true, IFF it was not
		# set to false by a previous iteration. This means that
		# this number is prime.
		# Now iterate through all multiples of this number within
		# the array and mark them as non-prime, since the can be
		# divided by i.
		reduce range(
			# 2*i is the first multiple of i after i
			2 * i;
			# Iterate over the rest of the array
			length;
			# Step size of i to hit all remaining multiples of i
			i
		) as $multiple_i (
			.;
			.[$multiple_i] = false
			)
	else
		# Already marked as composite by an earlier iteration
		. 
	end
;

.limit | build_sieve
| reduce range(2, length) as $i (
	.; 
	mark_composites($i)
)
| indices(true)

