hamming <- function(strand1, strand2, f = function(x) sum(x)) {

  if (any(!is.character(strand1), !is.character(strand2)))
    warning("Coercing non-character input")
  
  strand1 <- as.character(strand1)
  strand2 <- as.character(strand2)
  
  if (!(length(strand1) == 1 && length(strand2) == 1 
        && nchar(strand1) == nchar(strand2)))
    stop("Use length 1 strings of equal length for x and y")
  
  tokenize <- function(x)
    unlist(strsplit(as.character(x), ""))
  
  f(tokenize(strand1) != tokenize(strand2))
}

h_test <- function(f, n = 1e7) {
  
  runifasta <- function(n) paste0(collapse = "", 
    sample(c("A", "C", "T", "G"), n, replace = TRUE, prob = rep(1 / 4, 4)))
  
  fb1 <- runifasta(n)
  fb2 <- runifasta(n)
  
  f(fb1, fb2)

}

# pretty similar speed for the statements below
# I get 2.93s for the first (using sum), 2.88s for the last (using length(which))
#bench::mark(h_test(hamming))$median
#bench::mark(h_test(function(x, y) hamming(x, y, f = function(x) length(which(x)))))$median
