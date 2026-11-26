/**
* Your implementation of the RnaTranscription exercise
*/
component {
	
	/**
	* @returns 
	*/
	 function toRNA( DNA ) {
		// Implement me here
         var arrayDNA = DNA.listToArray("");
         var RNA = "";
         for (var ncl in arrayDNA){
             switch(ncl){
                 case "G":
                     RNA &= "C";
                     break;
                case "C":
                     RNA &= "G";
                     break;
                case "T":
                     RNA &= "A";
                     break;
                 case "A":
                     RNA &= "U";
                     break;
             }
         }
         return RNA;
	}
	
}