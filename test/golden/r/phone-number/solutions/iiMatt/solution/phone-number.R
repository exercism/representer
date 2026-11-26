parse_phone_number <- function(number_string) {
  chars <- unlist(strsplit(number_string, ''))
  nums <- as.numeric(chars[chars %in% as.character(0:9)])
  n <- length(nums)

  if (n < 10 || n > 11)
    return(NULL)

  if (n == 11 && nums[1] != 1)
    return(NULL)

  if (n == 11)
    nums <- nums[2:n]

  if (nums[1] < 2 || nums[4] < 2)
    return(NULL)

  return(paste(nums, collapse = ''))
}
