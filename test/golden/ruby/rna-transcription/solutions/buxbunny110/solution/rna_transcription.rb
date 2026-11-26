class Complement
  class << self
    def of_dna(nucleotide)
      return '' if nucleotide.empty?
      return get_complement(nucleotide) if nucleotide.length == 1
      result = ''
      nucleotide.each_char { |n| result += get_complement(n) }
      result 
    end
    private 
    def get_complement(nucleotide)
      case nucleotide
        when 'C'
        'G'
        when 'G'
        'C'
        when 'T'
        'A'
        when 'A'
        'U'
      end
    end
  end
end
