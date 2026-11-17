# initialize stays, because Ruby calls it.
def initialize(x, y)
  @letters = ("a".."z").to_a
  @pair = [x, y]
  coprime_check(key[0])
  @shifted = make_cipherbet.join
end
