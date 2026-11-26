local n0, list0
class Robot
  @reset_names: =>
    n0 = 26 * 26 * 10 * 10 * 10
    list0 = [ i for i = 0, n0 + 1 ]
  @get_name: =>
    assert n0 > 0, 'all names taken'
    n = n0
    l = list0
    n0 -= 1
    p = math.random 1, n
    if p != n
      l[p], l[n] = l[n], l[p]
    id = l[n]
    with res = ""
      base = (a, c0) -> ->
        i = id % a
        id = id // a
        res ..= string.char(c0\byte! + i)
      char = base 26, 'A'
      digit = base 10, '0'
      char!
      char!
      digit!
      digit!
      digit!

  new: => @reset!
  reset: => @name_ = @@get_name!
  name: => @name_

Robot\reset_names!

Robot
