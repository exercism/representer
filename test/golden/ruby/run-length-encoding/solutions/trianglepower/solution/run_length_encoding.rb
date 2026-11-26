module RunLengthEncoding
  def self.decode(input)
    out = ""
    
    input.scan(/([\d]*)(.)/).each do |pair|
      count, c = pair
      count = count.to_i

      if count == 0
        count = 1
      end

      count.times do
        out += c
      end        
    end

    return out
  end

  def self.encode(input)
    out = ""
    cur = nil
    curcount = 1
    
    input.chars.each.with_index do |c, i|
      d = input[i+1]

      puts "#{c} #{d}, #{out}, #{cur}, #{curcount}"
           
      if d && d == c
        cur = c
        curcount += 1
      elsif curcount > 1
        out += curcount.to_s
        out += cur
        #out += c

        cur = nil
        curcount = 1
      else
        out += c
      end
    end

    return out
  end
end