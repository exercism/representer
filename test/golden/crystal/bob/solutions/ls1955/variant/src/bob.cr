class String
  def yell?
    self != self.upcase && self != self.downcase
  end

  def question?
    self.strip.ends_with? '?'
  end

  def forceful_question?
    yell? && question?
  end
end

module Bob
  def self.hey(string : String) : String
    case string
    when .forceful_question?
      "Calm down, I know what I'm doing!"
    when .yell?
      "Whoa, chill out!"
    when .question?
      "Sure."
    when .blank?
      "Fine. Be that way!"
    else
      "Whatever."
    end
  end
end
