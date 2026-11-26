class TwoFer
  @twoFer: (name) ->
    name = "you" if not name
    return "One for #{name}, one fpr me."

module.exports = TwoFer
