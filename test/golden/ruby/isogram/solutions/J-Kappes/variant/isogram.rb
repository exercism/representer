class Isogram
  def self.isogram?(str)
    str = str.downcase.gsub(/[^a-z]/, '')
    for i in 0 .. str.length - 1
      current = str[i]
      for k in 0 .. i + 1
        if current == str[k]
          return false
        end
      end
    end
    true
  end
end
