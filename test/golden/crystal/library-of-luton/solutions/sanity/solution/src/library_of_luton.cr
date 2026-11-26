class Library
  def self.first_letter(title : String) : Char
    title[0]
  end

  def self.initials(first_name : String, last_name : String) : String
    "#{first_name[0]}.#{last_name[0]}"
  end

  def self.decrypt_character(character : Char) : Char
    if !character.letter?
      return character
    elsif character == 'a' || character == 'A'
      return character + 25
    end
    character.pred
  end

  def self.decrypt_text(text : String) : String
    text.each_char.map{ |char| self.decrypt_character(char) }.join
  end
end
