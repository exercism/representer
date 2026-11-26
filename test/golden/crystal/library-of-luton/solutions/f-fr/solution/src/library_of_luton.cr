class Library
  def self.first_letter(title : String) : Char
    title[0]
  end

  def self.initials(first_name : String, last_name : String) : String
    "#{first_name[0]}.#{last_name[0]}"
  end

  def self.decrypt_character(character : Char) : Char
    case character
    when 'a'..'z' then 'a' + (character - 'a' + 25) % 26
    when 'A'..'Z' then 'A' + (character - 'A' + 25) % 26
    else character
    end
  end

  def self.decrypt_text(text : String) : String
    text.chars.map(&->decrypt_character(Char)).join
  end
end
