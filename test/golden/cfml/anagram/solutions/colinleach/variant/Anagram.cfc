component {
	
	function anagrams( string subject, array candidates ) {
		var normedSubject = normed(subject);

		return candidates.filter(function(item){
			return item.uCase() != subject.uCase() && normed(item) != normedSubject;
		});
	}

	function normed(input) {
		// convert string to uppercase with letters sorted alphabetically
		return input.uCase()
					.listToArray('')
					.sort('text')
					.toList();
	};
}
