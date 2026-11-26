-- For convenience, define the letter values by tiers, but expand them into a
-- value table indexed by letter.

local letter_values = {}

local letter_tiers = {
  "AEIOULNRST",  -- 1
  "DG",          -- 2
  "BCMP",        -- 3
  "FHVWY",       -- 4
  "K",           -- 5
  "",
  "",
  "JX",          -- 8
  "",
  "QZ",          -- 10
}

for value, letters in ipairs(letter_tiers) do
  for letter in letters:gmatch(".") do
    letter_values[letter] = value
  end
end

-- Compute the score for a word.

local function score(word)
  local value = 0
  word = string.upper(word or "")
  for letter in word:gmatch("[A-Z]") do
    value = value + letter_values[letter]
  end
  return value
end

return { score = score }
