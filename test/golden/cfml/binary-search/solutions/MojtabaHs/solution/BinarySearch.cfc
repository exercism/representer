component {
	function find( array, value ) {
		start = 1
        stop = Len(array)
        while(start <= stop) {
            index = (start + stop) \ 2
            median = array[index]

            if (median == value) { return index } 
            
            if (median < value) {
                start = index + 1
            }  else {
                stop = index - 1
            }
        }
        throw 'value not in list'
	}
}