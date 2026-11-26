module Bob
  def self.hey(remark)
    remark = remark.strip
    is_question = remark.end_with? '?'
    is_yelling = (remark.upcase == remark) && remark.count("A-Z") > 0
    is_silence = remark.empty?

    if is_question && is_yelling
      "Calm down, I know what I'm doing!"
    elsif is_question
      "Sure."
    elsif is_yelling
      "Whoa, chill out!"
    elsif is_silence
      "Fine. Be that way!"
    else
      "Whatever."
    end
  end
end
