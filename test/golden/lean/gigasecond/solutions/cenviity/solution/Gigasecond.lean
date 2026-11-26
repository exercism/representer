import Std.Time

namespace Gigasecond

def add : Std.Time.PlainDateTime → Std.Time.PlainDateTime :=
  (·.addSeconds 1_000_000_000)

end Gigasecond
