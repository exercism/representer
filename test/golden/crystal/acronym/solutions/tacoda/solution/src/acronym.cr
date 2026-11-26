class Acronym
  def self.abbreviate(term)
    term.gsub(/-|_/, ' ')
        .split(/\s+/)
	.map { |w| w[0].upcase }
	.join
  end
end
