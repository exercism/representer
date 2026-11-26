handshake <- function(n) {
  messages <- c("wink", "double blink", "close your eyes", "jump")
  output <- messages[bitwAnd(n, 2^(0:3)) != 0]
  if (bitwAnd(n, 16)) output <- rev(output)
  switch(length(output) != 0, output)
}