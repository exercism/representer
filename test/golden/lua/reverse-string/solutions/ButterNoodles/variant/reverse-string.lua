return function(string)
  -- Do a for loop starting at the last index in the string
  -- Loop backward and append the current character to a new string
  -- This should build the reversed string in one pass

  local strLength = #string
  local reverseString = ""
  
  for i = strLength, 2, -1 do
    reverseString = reverseString .. string:sub(i, i)
  end

  return reverseString
end
