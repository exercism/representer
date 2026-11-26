class PigLatin
  VOWELS = /a|e|i|o|u/
  CONSONANTS = /[^#{VOWELS}]/
  def self.translate(phrase)
    phrase.split.map{|w| translate_word w}.join(' ')
  end
  def self.translate_word(word)
    parts = word.partition(/#{VOWELS}|#{CONSONANTS}*qu|xr|y/).reject(&:empty?)
    parts.rotate!(1) unless parts[0] =~ /^#{VOWELS}|(xr)/ or
      (parts[0] == 'y' and parts[1] =~ /^#{CONSONANTS}/)
    parts.join << 'ay'
  end
end
