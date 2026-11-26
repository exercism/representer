class TwoFer
  def self.two_fer(name = 1)
      if name == 1
        return "One for you, one for me."
      else
         return "One for #{name}, one for me."
      end
  end
end