import gleam/int
import gleam/list

pub type Command {
  Wink
  DoubleBlink
  CloseYourEyes
  Jump
}

pub fn commands(encoded_message: Int) -> List(Command) {
  let actions = [
    #(1, fn(x) { [Wink, ..x] }),
    #(2, fn(x) { [DoubleBlink, ..x] }),
    #(4, fn(x) { [CloseYourEyes, ..x] }),
    #(8, fn(x) { [Jump, ..x] }),
    #(16, fn(x) { list.reverse(x) }),
  ]
  list.fold(actions, [], fn(acc, x) {
    let #(n, action) = x
    case int.bitwise_and(encoded_message, n) > 0 {
      True -> action(acc)
      False -> acc
    }
  })
  |> list.reverse()
}
