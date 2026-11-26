class FlattenArray

	def self.flatten(array)
		array.flatten.compact
	end
end

#p FlattenArray.flatten([2,[3,4], [[45]]])