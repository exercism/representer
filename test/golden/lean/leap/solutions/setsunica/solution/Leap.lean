
namespace Leap

def leapYear (year : UInt16) : Bool :=
  let r d := year % d == 0
  match (r 400, r 100, r 4) with
  | (true, _, _) => true
  | (_, true, _) => false
  | (_, _, true) => true
  | _ => false

end Leap
