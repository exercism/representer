class Clock {
  construct new(hour, minute) {
    _h = hour
    _m = minute
    add(0)
  }

  add(m) {
    _h = ((_h + (_m + m) / 60).floor % 24 + 24) % 24
    _m = ((_m + m) % 60 + 60) % 60
  }

  subtract(m) {
    add(-m)
  }

  toString { "0%(_h)"[-2..-1] + ":" + "0%(_m)"[-2..-1] }

  ==(other) { toString == other.toString }
}
