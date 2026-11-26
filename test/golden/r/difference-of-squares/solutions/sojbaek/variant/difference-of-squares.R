# this is a stub function that takes a natural_number
# and should return the difference-of-squares as described
# in the README.md
difference_of_squares <- function(natural_number) {
  if (natural_number <= 1) numbers= 0  else numbers=1:natural_number;
  return(sum(numbers)^2 - sum(numbers^2));
}
