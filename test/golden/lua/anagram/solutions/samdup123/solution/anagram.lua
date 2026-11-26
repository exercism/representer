function compareTable(table1, table2)
  if #table1 ~= #table2 then return false end
  for i = 1, #table1 do
    if table1[i] ~= table2[i] then  return false end
  end
  return true
end

local function buildLetterBag(word)
  word = string.lower(word)
  local letterBag = {}
  for i = 1, #word  do table.insert(letterBag, string.byte(word, i)) end
  return letterBag
end

local Anagram = {}
Anagram.__index = Anagram
function Anagram:new(word)
  local obj = setmetatable({}, Anagram)
  self._word = word
  self.len = #word
  self._letterBag = buildLetterBag(word)
  self._sortedLetterCount = table.move(self._letterBag, 1, #self._letterBag, 1, {})
  table.sort(self._sortedLetterCount)
  return obj
end

function Anagram:match(wordTable)
  local matchesTable = {}
  for _, value in ipairs(wordTable) do
    local letterBag = buildLetterBag(value)
    if not compareTable(self._letterBag, letterBag) then
      table.sort(letterBag)
      if compareTable(self._sortedLetterCount, letterBag)
      then table.insert(matchesTable, value) end
    end
  end
  return matchesTable
end

return Anagram