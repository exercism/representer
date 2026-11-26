/**
* Your implementation of the ListOps exercise
*/
component {

	/**
	* @returns
	*/
	function append( list1, list2 ) {
		// Implement me here
		var listP =  myIsList(list1)?  listToArray(list1) : duplicate(list1);
    	var listS =  myIsList(list2)?  listToArray(list2) : duplicate(list2);
    	len = length(listP);
    	for(var i=1;i<=length(listS);i++){
    	    listP[len+i] = listS[i];
    	}
    	return listP;
	}

	/**
	* @returns
	*/
	function concat( lists ) {
		// Implement me here
		var listN = [];
    	for(var list in lists){
    	    var aus = myIsList(list)?  listToArray(list) : duplicate(list);
    	    listN=append(listN,aus);
    	}
    	return listN;
	}

	/**
	* @returns
	*/
	function filter( list, fn ) {
		// Implement me here
		var listAus = myIsList(list)?  listToArray(list) : duplicate(list);
    	var listN = [];
    	var i = 1;
    	for(item in listAus){
    	    if(fn(item)){
    	        listN[i] = item;
    	        i++;
    	    }
    	}
	
    	return listN;
	}

	/**
	* @returns
	*/
	function length( list ) {
		// Implement me here
		var listN =  myIsList(list)? listToArray(list) : duplicate(list);
    	var c = 0;
    	for(var li in listN){
    	    c++;
    	}
    	return c;

	}

	/**
	* @returns
	*/
	function map( list, fn ) {
		// Implement me here
		var listAus = myIsList(list)?  listToArray(list) : duplicate(list);
    	var listN = [];
    	var i = 1;
    	for(item in listAus){
    	    listN[i] = fn(item);
    	    i++;
    	}
	
    	return listN;

	}

	/**
	* @returns
	*/
	function foldl( list, fn, initial ) {
		// Implement me here
		var listAus = myIsList(list)?  listToArray(list) : duplicate(list);
    	for(item in listAus){
    	    initial = fn(initial,item);
    	}
    	return initial;
	}

	/**
	* @returns
	*/
	function foldr( list, fn, initial ) {
		// Implement me here
		var listAus = myIsList(list)?  listToArray(list) : duplicate(list);
    	for (i = length(listAus); i >= 1; i--) {
    	    initial = fn(initial,listAus[i]);
    	}
    	return initial;
	}

	/**
	* @returns
	*/
	function reverse( list ) {
		// Implement me here
		var listAus = myIsList(list)?  listToArray(list) : duplicate(list);
    	var listN = [];
    	var j=1;
    	for (i = length(listAus); i >= 1; i--) {
    	    listN[j] = listAus[i];
    	    j++;
    	}
    	return listN;
	}

	function isString(val) {
    return isSimpleValue(val) or getMetaData(val).name eq "java.lang.String";
	}

	function myIsList(val) {
   	return isSimpleValue(val) and getMetaData(val).name eq "java.lang.String" and find(",", val) > 0;
	}
}