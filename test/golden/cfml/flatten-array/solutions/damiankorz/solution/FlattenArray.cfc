component {
	/**
	* @returns
	*/
	public void function flattenNested( required array nested, required array output ){
		for( var i = 1; i <= arrayLen( nested ); i++ ){
			if( isNull(nested[i]) ){
				nested[i] = "";
			}
			if( !isArray(nested[i]) && len(nested[i]) ){
		        arrayAppend(output, nested[i]);
		    }
		    if( isArray(nested[i]) && len(nested[i]) ){
		        flattenNested(nested[i], output);
		    }
		}
	}
	public array function flatten( required array array ) {
		var output = [];
		for(var i = 1; i <= arrayLen(array); i++){
			if( isNull(array[i]) ){
				array[i] = "";
			}
		   if( !isArray(array[i]) && len(array[i]) ){
		        arrayAppend(output, array[i]);
		    }
		   if( isArray(array[i]) && !isNull(array[i]) ){
		        flattenNested(array[i], output);
		   }
		}
		return output;
	}
}