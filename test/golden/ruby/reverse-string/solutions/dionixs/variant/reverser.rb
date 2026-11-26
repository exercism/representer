module Reverser
  def self.reverse(str)
    new_str = ""
    i = -1

    while str[i]
      new_str << str[i]
      i -= 2
    end

    new_str
  end
end

