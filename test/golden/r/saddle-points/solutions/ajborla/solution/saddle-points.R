# ----------------------------------------------------------------------------
# exercism.org
# R Track Exercise: saddle-points
# Contributed: Anthony J. Borla (ajborla@bigpond.com)
# ----------------------------------------------------------------------------

saddle_point <- function(input) {
  # Bail on empty matrix
  if (length(input) == 0) data.frame(row=numeric(), col=numeric()) 
  else {
    # Extract input dimensions
    nrows <- nrow(input) ; ncols <- ncol(input)
  
    # Construct logical matrix matching input dimensions. This will
    #  be the 'saddle-point mask'
    maxrminc <- matrix(FALSE, ncol = ncols, nrow = nrows, byrow = TRUE)
  
    # Determine max. and min. for each row, column, respectively
    maxr <- apply(input, 1, max)
    minc <- apply(input, 2, min)
  
    # Traverse matrix element-wise marking saddle points in the corresponding
    #  logical matrix (mask)
    for (r in 1:nrows)
      for (c in 1:ncols)
        maxrminc[r, c] <- input[r, c] >= maxr[r] & input[r, c] <= minc[c]
  
    # Return empty dataframe if no saddle-points found 
    if (all(!maxrminc)) data.frame(row=numeric(), col=numeric()) 
    else 
      # Return row, column of each saddle-point
      data.frame(which(maxrminc, arr.ind=TRUE))
  }
}
