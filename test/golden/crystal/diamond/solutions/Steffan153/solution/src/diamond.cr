module Diamond
  def self.rows(letter : Char) : Array(String)
    num = letter - 'A'
    arr = (0..num).map do |n|
      str = ('A' + n) + " " * n
      (str + str.reverse[1..]).center(num * 2 + 1)
    end
    arr + arr.reverse[1..]
  end
end
