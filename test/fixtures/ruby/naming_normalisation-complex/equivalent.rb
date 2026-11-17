class A
  def bark = 'foo'

  def c
    bark = 'cat'
    return A.bark
  end
end
