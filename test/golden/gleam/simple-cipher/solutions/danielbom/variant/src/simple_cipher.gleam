import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/string

const alphabet = "abcdefghijklmnopqrstuvwxyz"

type Cipher {
  Cipher(distances: List(Int), map: Dict(String, Int), rmap: Dict(Int, String))
}

pub fn encode(plaintext plaintext: String, key key: String) -> String {
  new(key, forward: True) |> apply(plaintext)
}

pub fn decode(ciphertext ciphertext: String, key key: String) -> String {
  new(key, forward: False) |> apply(ciphertext)
}

fn apply(cipher: Cipher, text: String) -> String {
  case cipher.distances {
    [] -> text
    _ -> apply_loop(cipher, string.to_graphemes(text), cipher.distances, "")
  }
}

fn apply_loop(
  cipher: Cipher,
  chars: List(String),
  distances: List(Int),
  result: String,
) -> String {
  case chars, distances {
    [], _ -> result
    _, [] -> apply_loop(cipher, chars, cipher.distances, result)
    [c, ..chars], [d, ..distances] -> {
      let result = result <> rotate(cipher, c, d)
      apply_loop(cipher, chars, distances, result)
    }
  }
}

fn rotate(cipher: Cipher, ch: String, d: Int) -> String {
  case dict.get(cipher.map, ch) {
    Ok(ix) -> {
      let assert Ok(out) = dict.get(cipher.rmap, { ix - d + 26 } % 26)
      out
    }
    Error(_) -> ch
  }
}

pub fn generate_key() -> String {
  let n = string.length(alphabet)
  list.fold(list.range(1, 100), "", fn(acc, _) {
    acc <> string.slice(alphabet, int.random(n), 1)
  })
}

fn new(key: String, forward forward: Bool) -> Cipher {
  let map =
    list.index_fold(
      string.to_graphemes(alphabet),
      dict.new(),
      fn(acc, value, index) { dict.insert(acc, value, index) },
    )
  let rmap =
    list.index_fold(
      string.to_graphemes(alphabet),
      dict.new(),
      fn(acc, value, index) { dict.insert(acc, index, value) },
    )
  let distances =
    list.map(string.to_graphemes(key), fn(ch) {
      case dict.get(map, ch), forward {
        Ok(ix), True -> ix
        Ok(ix), False -> -ix
        Error(_), _ -> 0
      }
    })
  Cipher(distances: distances, map: map, rmap: rmap)
}
