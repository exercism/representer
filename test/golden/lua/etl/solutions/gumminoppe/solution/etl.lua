
return {
  transform = function(dataset)
    local new_dataset = {}
    for score, letters in pairs(dataset) do
      for _, letter in ipairs(letters) do
        new_dataset[letter:lower()] = score
      end
    end
    return new_dataset
  end
}

