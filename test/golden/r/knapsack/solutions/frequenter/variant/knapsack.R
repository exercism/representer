maximum_value <- \(max_weight, items) {
  if (length(items) == 0) { return(0) }
  x <- as.data.frame(t(sapply(items, as.integer)))
  names(x) <- c('wt', 'val')
  pool <- data.frame(lb=0, ub=sum(x[, 2]), rw=max_weight)
  max_val <- 0
  for (i in 1:nrow(x)) {
    new_pool <- NULL
    for (j in 1:nrow(pool)) {
      # branch including items[[i]]:
      lb <- pool[j, 1]+x$val[i]
      ub <- pool[j, 2]
      rw <- pool[j, 3]-x$wt[i]
      if (rw >= 0 && lb == ub) {
        max_val <- max(max_val, lb)
      } else if (rw >= 0 || lb < ub) {
        new_pool <- rbind(new_pool, c(lb, ub, rw))
      }
      # branch not including items[[i]]:
      lb <- pool[j, 1]
      ub <- pool[j, 2]-x$val[i]
      rw <- pool[j, 3]
      if (rw >= 0 && lb == ub) {
        max_val <- max(max_val, lb)
      } else if (rw >= 0 && lb < ub) {
        new_pool <- rbind(new_pool, c(lb, ub, rw))
      }
    }
    if (is.null(new_pool)) { break }
    pool <- new_pool
  }
  max_val
}
