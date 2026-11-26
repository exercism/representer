module RailFenceCipher
  def self.cycle_rails(rail_count)
    rail_ix = 0
    dir = 1
    while true
      yield rail_ix
      case rail_ix + dir
      when -1, rail_count
        dir = -dir
      end
      rail_ix += dir
    end
  end

  def self.encode(rail_count, plaintext)
    rails = Array(String).new(rail_count, "")
    chars_iter = plaintext.each_char

    cycle_rails(rail_count) do |rail_idx|
      case ch = chars_iter.next
      when Char then rails[rail_idx] += ch
      else
        break
      end
    end

    rails.join
  end

  def self.decode(rail_count, ciphertext)
    rails_placeholder = Array(String).new(rail_count, "")
    chars_iter = ciphertext.each_char

    cycle_rails(rail_count) do |rail_idx|
      case ch = chars_iter.next
      when Char then rails_placeholder[rail_idx] += "X"
      else
        break
      end
    end

    rail_start = 0
    rails = rails_placeholder.map do |rail|
      rail_end = rail_start - rail.size - 1
      r2 = ciphertext[rail_start..rail_end].chars
      rail_start = rail_end + 1
      r2
    end

    String.build do |str|
      cycle_rails(rail_count) do |rail_idx|
        str << rails[rail_idx].shift?
        break if rails.all? { |r| r.size == 0 }
      end
    end
  end
end
