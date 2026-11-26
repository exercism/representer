import gleam/bool
import gleam/int
import gleam/list
import gleam/string

pub fn encode(plaintext: String) -> String {
  plaintext
  |> string.to_graphemes()
  |> list.chunk(fn(grapheme) {grapheme})
  |> list.map(
    fn(group)
    {
      let assert [grapheme, ..] = group

      case list.length(group)
      {
        1 -> grapheme
        i if i > 1 -> int.to_string(i) <> grapheme
        _ -> panic
      }
      
    }
  )
  |> string.concat()
}

const numbers = "1234567890"

fn decode_list(cipher, result)
{
  use <- bool.guard(list.is_empty(cipher), result)

  let #(nb, tail) = list.split_while(cipher, fn(grapheme) { string.contains(numbers, grapheme)})
  let assert Ok(letter) = list.first(tail)

  case nb
  {
    [] -> decode_list(list.drop(tail, 1), result <> letter)
    _ ->
    {
      let assert Ok(parsed_number) = int.parse(string.concat(nb))
      decode_list(list.drop(tail, 1), result <> string.repeat(letter, parsed_number))
    }
  }
}

pub fn decode(ciphertext: String) -> String {
  ciphertext
  |> string.to_graphemes()
  |> decode_list("")
}
