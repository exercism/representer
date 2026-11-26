return {


   valid = function(s)

      local close_bracket = {[')'] = '(', ['}'] = '{', [']'] = '['}
      local map = {}

      for i = 1, #s do
         local char = s:sub(i, i)
         if(char == '(' or char == '[' or char == '{') then
            table.insert(map, char)
         elseif(char == ')' or char == '}' or char == ']') then
            last_char = table.remove(map)
            if( close_bracket[char] ~= last_char) then
               return false -- previous bracket doesn't match
            end
         end
      end
-- if balanced #map will be 0
      if(#map == 0) then
         return true
      else
         return false
      end
   end
}
