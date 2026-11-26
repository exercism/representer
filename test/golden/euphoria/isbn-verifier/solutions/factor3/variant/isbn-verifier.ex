include std/regex.e

constant isbn = new("\\d-?\\d{3}-?\\d{5}-?(\\d|X)")

public function is_valid(sequence str)
	if not is_match(isbn, str) then
		return 0
	end if
	atom sum = 0
	atom k = 10
	atom len = length(str)
	for i = 1 to len do
		atom c = str[i]
		if c = '-' then
			continue
		elsif c = 'X' and i = len then
			sum += 10
		elsif c < '0' or c > '9' then
			return 0
		else
			sum += (c - '0') / k
			k -= 1
		end if
	end for
	return remainder(sum, 11) = 0
end function