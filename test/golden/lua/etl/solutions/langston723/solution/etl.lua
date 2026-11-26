return {
	transform = function(dataset)
		local transformed = {}

		for score, letters in pairs(dataset) do
			for _, letter in ipairs(letters) do
				transformed[string.lower(letter)] = score
			end
		end

		return transformed
	end,
}
