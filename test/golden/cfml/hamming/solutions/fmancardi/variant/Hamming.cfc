/**
* Your implementation of the Hamming exercise
*/
component {
	
	/**
	* @returns 
	*/
	 function distance( strand1, strand2 ) {
		// Implement me here
       local.strandLen = len(arguments.strand1);
       if (local.strandLen == len(arguments.strand2)) {
           throw(message = 'left and right strands must be of equal length');
       }

       local.hammingDistance = 0;
       for(local.idx=1; local.idx <= local.strandLen;local.idx++) {
        
        // treat string like array
        if (arguments.strand1[local.idx] != arguments.strand2[local.idx]) {
          local.hammingDistance++;  
        }
       }
       return local.hammingDistance;
	}
	
}