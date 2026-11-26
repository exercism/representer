# Please implement your solution to acronym in this file
module Acronym
 def self.abbreviate(s)
    s.split(/[ .,\/#!$%\^&\*;:{}=\-_`~()]+/).map {|word| word[0].upcase } .join
 end
end
