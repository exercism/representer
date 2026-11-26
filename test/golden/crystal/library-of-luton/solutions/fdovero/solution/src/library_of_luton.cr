class Library
  def self.first_letter(title : String) : Char
    title[0]
  end

  def self.initials(first_name : String, last_name : String) : String
    "#{first_letter(first_name)}.#{first_letter(last_name)}"
  end

  def self.decrypt_character(character : Char) : Char
    if character == 'a'
      'z'
    elsif character == 'A'
      'Z'
    elsif !character.letter?
      character
    else
      character.pred
    end
  end

  def self.decrypt_text(text : String) : String
    text.chars.reduce("") { |str, char| str + decrypt_character(char) }
  end
end
