module SecretHandshake

  SIGNALS = [
    {1, "wink"},
    {2, "double blink"}, 
    {4, "close your eyes"}, 
    {8, "jump"},
    ]

  def self.commands(input : Int32) : Array(String)
    output = [] of String
    SIGNALS.each do |num, verb|
      if (input & num) != 0
        output << verb
      end
    end

    if (input & 16) != 0
      output.reverse!
    end

  output

  end

end
