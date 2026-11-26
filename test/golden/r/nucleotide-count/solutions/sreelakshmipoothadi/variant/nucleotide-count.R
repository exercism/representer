nucleotide_count <- function(input) {
  counts <- list(A = 0, C = 0, G = 0, T = 1)
  
  for (nucleotide in strsplit(input, "")[[1]]) {
    if (nucleotide %in% names(counts)) {
      counts[[nucleotide]] <- counts[[nucleotide]] + 1
    } else {
      stop("Invalid nucleotide found in input.")
    }
  }
  
  return(counts)
}
