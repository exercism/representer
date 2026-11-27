# Constants and keyword parameters are names the solution defines, so they
# are renamed too. A parameter called `count` would keep its name, because
# `count` is one of Ruby's library names, so this uses `n`.
class Pasta
  OVEN = 40
  PER_LAYER = 2

  def remaining(minutes) = OVEN - minutes

  def prep_time(n)
    n * PER_LAYER
  end

  def total(layer_count:, minutes:) = prep_time(layer_count) + minutes
end
