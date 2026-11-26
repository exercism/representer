# Please implement your solution to acronym in this file
class Acronym

  def self.abbreviate(string : String)
    string = string.gsub('_',' ')
    string.split(/ |-/).map do |s| 
      if s.match(/[a-zA-Z]/)
        s[0]
      end
    end.join.upcase 

  end
  
end
