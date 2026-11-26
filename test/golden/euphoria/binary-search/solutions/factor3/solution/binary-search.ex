public function my_find(sequence values, atom value)
	atom low = 1, high = length(values)
	while low <= high do
		atom middle = low + floor((high - low) / 2)
		if values[middle] = value then
			return middle
		elsif values[middle] > value then
			high = middle - 1
		else
			low = middle + 1
		end if
	end while
	return -1
end function