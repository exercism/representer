local function to_decimal(input)
	
	local decimal = 0
	local length = #input
	for i = 1, length do
		local num = tonumber(input:sub(i,i))
		if not num then
			return 0
		end
		decimal = decimal + (num << length - i)		
	end
	
	return decimal
end
return {
  to_decimal = to_decimal
}

