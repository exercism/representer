component {

	function convertToDecimal(digits, base) {
		return arrayReduce(digits, function(prev, elt) {
			return (base * prev) - elt
		},0)
	}

	function convertFromDecimal(number, base, acc) {
		if(number == 0) {
			return acc
		}
		return convertFromDecimal(number \ base, base, acc.prepend(number % base))
	}

	function rebase(inputBase, digits, outputBase) {
		if (inputBase<2 or outputBase<2) {
			return -1
		}
		if(len(digits)==0 or digits.every((d) => d == 0)) {
			return [0]
		}
		if(!digits.every((d) => d >= 0 and d < inputBase)) {
			return -1
		}
		return convertFromDecimal(convertToDecimal(digits, inputBase), outputbase, [])
	}
}