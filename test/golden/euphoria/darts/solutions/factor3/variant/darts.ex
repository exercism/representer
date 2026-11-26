public function score(atom x, atom y)
	atom distance = sqrt(x * x + y * y)
	if distance <= 1.0 then
		return 10
	elsif distance <= 5.0 then
		return 5
	elsif distance < 10.0 then
		return 1
	else
		return 0
	end if
end function