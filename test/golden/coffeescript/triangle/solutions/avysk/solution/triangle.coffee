class Triangle
  constructor: (a, b, c) ->
    if a < b + c and b < a + c and c < a + b
      @correct = true
      @a = a
      @b = b
      @c = c
    else
      @correct = false

  equilateral: -> @correct and @a == @b and @b == @c

  isosceles: -> @correct and (@a == @b or @a == @c or @b == @c)

  scalene: -> @correct and @a != @b and @b != @c and @a != @c

module.exports = Triangle
