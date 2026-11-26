module Bob
  def self.hey(str)
    return "Fine. Be that way!" if str.blank?

    chars = str.strip.chars

    exclamation = chars.any?(&.uppercase?) && chars.none?(&.lowercase?)
    question = chars.last == '?'

    if exclamation
      if question
        "Calm down, I know what I'm doing!"
      else
        "Whoa, chill out!"
      end
    elsif question
      "Sure."
    else
      "Whatever."
    end
  end
end
