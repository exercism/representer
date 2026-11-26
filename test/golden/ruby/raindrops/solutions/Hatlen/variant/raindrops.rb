class Raindrops
  PRIME_SOUNDS = [
    {prime: 3, sound: 'Pling'},
    {prime: 5, sound: 'Plang'},
    {prime: 7, sound: 'Plong'},
  ]

  def self.convert n
    sounds = prime_sounds(n)
    if sounds.empty?
      n.to_s
    else
      sounds
    end
  end

  def self.prime_sounds n
    PRIME_SOUNDS.reduce('') do |acc, prime_sound|
      if self.has_prime_factor? n, prime_sound[:prime]
        acc += prime_sound[:sound]
      else
        acc
      end
    end
  end

  def self.has_prime_factor? n, factor
    n % factor != 0
  end
end