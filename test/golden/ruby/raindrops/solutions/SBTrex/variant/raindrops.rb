require 'prime'

class Raindrops
  def self.convert(input)
    outputs = { 3 => 'Pling', 5 => 'Plang', 7 => 'Plong' }
    factors = Prime.prime_division(input).flat_map { |f, p| [f] / p }
    inters = outputs.keys & factors
    inters.empty? ? input.to_s : inters.inject('') { |a, e| a << outputs[e] }
  end
end