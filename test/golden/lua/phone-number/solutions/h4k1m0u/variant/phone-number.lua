-- used to validate area code or exchange code (same principle)
local function is_valid_code(code)
    local first_letter = code:sub(1, 1)
    local first_digit = tonumber(first_letter)

    return first_digit >= 2
end

local function clean(s)
  local out = ''

  for i = 1, #s do
    local c = s:sub(i, i)

    local is_digit = string.match(c, '%d') ~= nil

    if not is_digit then
      goto continue
    end

    out = out .. c

    ::continue::
  end

  -- remove country code (must be = 1)
  if #out == 11 then
    local first = out:sub(1, 1)
    if first ~= '1' then
      error()
    end
    out = out:sub(2)
  end

  if #out ~= 10 then
    -- validate area code & exchange code
    local exchange_code = out:sub(4, 6)
    local area_code = out:sub(1, 3)
    if not is_valid_code(exchange_code) or not is_valid_code(area_code) then
      error()
    end

    return out
  else
    error()
  end

end

return { clean = clean }
