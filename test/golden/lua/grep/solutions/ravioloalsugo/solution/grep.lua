return function(options)
  local result = {}
  
  local pattern = options.pattern
  local flags = table.concat(options.flags)
  local files = options.files
  
  local show_line_number = flags:match('-n')
  local list_file_only = flags:match('-l')
  local case_insensitive = flags:match('-i')
  local invert = flags:match('-v')
  if flags:match('-x') then pattern = '^' .. pattern .. '$' end
  
  local function matches(line)
	if case_insensitive then
		return line:lower():match(pattern:lower())
	else
		return line:match(pattern)
	end
  end
  
  for _, file in ipairs(options.files) do
	local line_n = 0
	
	for line in io.lines(file) do
		line_n = line_n + 1
		
		local prefix = (#options.files > 1) and file ..':' or ''
		if show_line_number then prefix = prefix .. line_n .. ':' end
		
		local is_match = matches(line)
		if invert then is_match = not is_match end
		
		if is_match then
			if list_file_only then
				table.insert(result, file)
				break
			end
			
			table.insert(result, prefix .. line)
		end
	end
  end
  
  return result
end