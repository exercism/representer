class Library
  def self.first_letter(title : String) : Char
    title[0]
  end

  def self.initials(first_name : String, last_name : String) : String
    "#{first_name[0]}.#{last_name[0]}"
  end

  def self.decrypt_character(character : Char) : Char
    if character == 'a'
      'z'
    elsif character == 'A'
      'Z'
    else
      character.pred
    end
  end

  def self.decrypt_text(text : String) : String
    text.chars.map{ |char| char.letter? ? self.decrypt_character(char) : char }.join
  end
end
