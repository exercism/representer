# Placeholder for `.two_fer` and its related logic.
#
# @author Rojo {https://rojo.github.io}
class TwoFer

  # Builds a `2-fer` string. If a name is given, it is placed in it.
  #
  # @param name [String, nil] Defaults to `you`
  # @return [String]
  def self.two_fer(name='you')
    "One for #{name}, one for me."
  end
end
