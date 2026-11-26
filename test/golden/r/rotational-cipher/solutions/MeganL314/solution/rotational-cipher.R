rotate <- function(text, key) {
	lower = strsplit('abcdefghijklmnopqrstuvwxyz', split = "")[[1]]
	capital = strsplit('ABCDEFGHIJKLMNOPQRSTUVWXYZ', split = "")[[1]]


	if (key == 26){
		lower_cipher = lower
		capital_cipher = capital
	}
	else{
		lower_cipher = c(lower[(key+1):length(lower)], lower[1:key])
		capital_cipher = c(capital[(key+1):length(capital)], capital[1:key])
	}
	
	#print(lower)
	#print(lower_cipher)
	#print(capital)
	#print(capital_cipher)
	
	new_string <- ""
	 
	characters = strsplit(text, split = "")[[1]]
	for (character in characters){
		if (character %in% lower_cipher){
			idx_to_match <- match(character, lower)
			print(paste("lowercase index to match: ", idx_to_match, collapse=""))
			new_string = paste0(new_string, lower_cipher[idx_to_match], collapse="")
		}
		else if (character %in% capital_cipher){
			idx_to_match <- match(character, capital)
			print(paste("uppercase index to match: ", idx_to_match, collapse=""))
			print(paste("uppercase original: ", character, collapse=""))
			print(paste("uppercase new: ", capital_cipher[idx_to_match], collapse=""))
			
			new_string = paste0(new_string, capital_cipher[idx_to_match], collapse="")
		}
		else {
			new_string = paste0(new_string, character, collapse="")
		}
	}
	print(new_string)
	return(new_string)	
	
}

