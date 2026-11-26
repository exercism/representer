function binarysearch(list::Vector, element; rev::Bool=false, lt=<, by=identity)::UnitRange
	if by ≠ identity
		element = by(element)
	end
	function halve(left, right)
		if left == right-1 return left:left-1 end
		middle = (left + right) ÷ 2
		middle_element = by(list[middle])
		if middle_element == element return middle:middle end
		if rev
			return lt(middle_element, element) ? halve(left, middle) : halve(middle, right)
		else
	 		return lt(element, middle_element) ? halve(left, middle) : halve(middle, right)
		end
	end

	if length(list) == 0 return 1:0 end
	left = firstindex(list)
	right = lastindex(list)
	if element == by(list[left]) return left:left
	elseif element == by(list[right]) return right:right
	else return halve(1, length(list))
	end
end