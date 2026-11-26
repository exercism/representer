saddle_point <- function(input) {
    rmax <- apply(input, 1, max, -Inf)
    cmin <- apply(input, 2, min, Inf)
    mask <- outer(rmax, cmin, FUN = "==")
    data.frame(which(mask, arr.ind = TRUE))
}
