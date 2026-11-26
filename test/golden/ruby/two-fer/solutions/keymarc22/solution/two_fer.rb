class TwoFer
  def self.two_fer(*fer)
    fer.empty? ? TwoFer.one_for_you : TwoFer.one_for_other(fer)
  end

  def self.one_for_you
    "One for you, one for me."
  end

  def self.one_for_other(name)
    "One for #{name[0]}, one for me."
  end
end
