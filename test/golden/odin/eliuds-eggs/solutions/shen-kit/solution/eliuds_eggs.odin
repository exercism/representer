package eliuds_eggs

egg_count :: proc(number: uint) -> uint {
  count: uint = 0
  for curr := number; curr > 0; curr >>= 1 {
    count += curr & 1
  }
	return count
}
