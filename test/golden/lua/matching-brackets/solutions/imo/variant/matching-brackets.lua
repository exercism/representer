local bracket_push = {}
local brackets = {
  { '{', '}' },
  { '(', ')' },
  { '[', ']' }
}

-- check if char is an opening bracket
local function is_open_bracket(char)
  for _, bt in ipairs(brackets) do
    if bt[1] == char then
      return true
    end
  end

  return false
end

-- check if closing char belongs to opening char
local function belong_together(o_char, c_char)
  for _, bt in ipairs(brackets) do
    if bt[1] == o_char then
      return bt[2] ~= c_char
    end
  end

  return false
end


-- if str is empty return directly
function bracket_push.valid(str)
  if str == '' then return true end

  local stack = {}

  -- iterate over every char in given string
  for i = 1, #str do
    local char = str:sub(i, i)
    -- if char is no alphanumeric char continue, else next char
    if char:find('[{}()%[%]]') then
      -- if it's an opening bracket add to stack
      if is_open_bracket(char) then
        table.insert(stack, char)
      else
        -- if it's not an opening bracket, check if stack is empty or
        -- the char belongs to opening char which is on top of the stack
        if #stack == 0
        or not belong_together(table.remove(stack, #stack), char) then
          return false
        end
      end
    end
  end

  -- if stack is not empty on this point, something went wrong
  return #stack == 0
end

return bracket_push