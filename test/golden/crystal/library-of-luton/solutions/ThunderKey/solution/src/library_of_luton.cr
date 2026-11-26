class Library
  def self.first_letter(title : String) : Char
    title[0]
  end

  def self.initials(first_name : String, last_name : String) : String
    "#{first_letter first_name}.#{first_letter last_name}"
  end

  def self.decrypt_character(character : Char) : Char
    decrypt_character(character, 'a', 'z') ||
      decrypt_character(character, 'A', 'Z') ||
      character
  end

  private def self.decrypt_character(character : Char, min : Char, max : Char) : Char?
    return nil unless (min..max).includes? character
    min + (character - 1 - min) % (max - min + 1)
  end

  def self.decrypt_text(text : String) : String
    text.chars.map {|c| decrypt_character c }.join
  end
end
