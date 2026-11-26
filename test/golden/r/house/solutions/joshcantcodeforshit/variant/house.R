full <- function() {
n <- c("malt", "rat", "cat", "dog", "cow with the crumpled horn", "maiden all forlorn", "man all tattered and torn", "priest all shaven and shorn", "rooster that crowed in the morn", "farmer sowing his corn", "horse and the hound and the horn")
v <- c("lay", "ate", "killed", "worried", "tossed", "milked", "kissed", "married", "woke", "kept", "belonged to")

meat <- c()
output <- c("This is the house that Jack built.")
seq <- 1:12
	for (i in seq[seq > 1]) {
    	if (i != 2) {
        	meat <- c(c(n[i-1], "that", v[i-1], "in the house that Jack built.", meat))
        }
        else {meat <- c(n[i-1], "that", v[i-1], "the", meat)}
        cat <- paste(meat, collapse = " ")
        output <- c(output, paste("This is the", cat, collapse = " "))
    }
return(output)
}

recite <- function(start_verse, end_verse) {
	full()[start_verse:end_verse]
}