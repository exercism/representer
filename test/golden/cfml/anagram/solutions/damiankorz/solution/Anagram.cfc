component {
	/**
	* @returns
	*/
	public array function anagrams( string subject, array candidates ) {
		if( subject != candidates[1]){
			subject = listSort( subject, "textnocase", "asc", "");
			var output = [];
			for( var i = 1; i <= arrayLen(candidates); i++ ){
				var candidate = listSort( candidates[i], "textnocase", "asc", "");
				if( candidate == subject ){
					arrayAppend(output, candidates[i]);
				}
			}
			return output;
		}else{
			return [];
		}
	}
}