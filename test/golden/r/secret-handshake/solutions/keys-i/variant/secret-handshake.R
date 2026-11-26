handshake <- function(num) {
  act <- c("wink", "double blink", "close your eyes", "jump");res <-c();res <- act[which(bitwAnd(num, 2^(0:3)) != 0)];if (bitwAnd(num, 16))res <- rev(res);ifelse(length(res)!=0,return(NULL),return(res))
}
