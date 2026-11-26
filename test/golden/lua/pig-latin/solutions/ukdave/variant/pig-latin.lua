local translate_word

local translate = function(phrase)
  return phrase:gsub("%w+", translate_word)
end

translate_word = function(word)
  -- rule 1
  if word:match("^[aeiou]") and word:match("^xr") or word:match("^yt") then
    return word .. "ay"
  end

  -- rule 3
  local match = word:match("^([^aeiou]*qu)")
  if match then
    return word:sub(#match + 1) .. match .. "ay"
  end

  -- rule 4
  match = word:match("^([^aeiou]+y)")
  if match then
    return "y" .. word:sub(#match + 1) .. match:sub(1, -2) .. "ay"
  end

  -- rule 2
  match = word:match("^([^aeiou]+)")
  if match then
    return word:sub(#match + 1) .. match .. "ay"
  end

  return word
end

return translate