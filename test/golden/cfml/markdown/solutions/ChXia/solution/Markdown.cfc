/**
* Your implementation of the Markdown exercise
*/
component {
	
	/**
	* @returns string
	*/
	function parse( required string markdown ) {
		
		var lines = listToArray(arguments.markdown, chr( 10 ));
		var output = [];
		var isInList = false;

		for(var line in lines){
			
			var matches = reMatchNoCase("^[##]+(.*)", line);
			if(matches.len()){
				var hLevel = reMatchNoCase("[##]+", matches[1])[1];
				line = "<h#hLevel.len()#>" & trim(replace( matches[1], hLevel, "")) & "</h#hLevel.len()#>";
			}

			else if(reMatchNoCase( "\*(.*)", line)){
				var cleanText = reReplace(line, "^\*\s*", "");
				var formattedText = parseInLineStyle(cleanText);

				if(!isInList){
					isInList = true;
					line = "<ul><li>" & formattedText & "</li>";
				} 
                else
				    line = "<li>" & formattedText & "</li>";
			} 
			else{
				if(isInList){
					line = "</ul>" & line;
					isInList = false;
				}
			}
			if (!reMatchNoCase( "<h|<ul|<p|<li", line).len()){
				var formattedText = parseInLineStyle(line);
				line = "<p>" & formattedText & "</p>";
			}

			output.append(line);
		}

		var html = arrayToList(output, "");
		if(isInList){
			html &= "</ul>";
		}

		return html;
	}

	/**
	* @returns string
	*/
	function parseInLineStyle( required string text ) {
		var newText = arguments.text.reReplace("__(.*?)__", "<strong>\1</strong>", "all");
		newText = newText.reReplace("_(.*?)_", "<em>\1</em>", "all");
		
		return newText;
	}
}