import gleam/list
import gleam/string
import gleam/result

pub fn find_anagrams(word: String, candidates: List(String)) -> List(String) {
  list.filter(candidates, fn(cand) { 
    string.length(word) == string.length(cand)
    && string.lowercase(word) != string.lowercase(cand) 
    && {
      let candemes = string.to_graphemes(cand) 
      let wordemes = string.to_graphemes(word)
      let left_overs = list.fold(candemes, wordemes, fn(word_list, char) {
        let poppers = list.pop(word_list, fn(letter) { 
          string.lowercase(letter) == string.lowercase(char)
        }) 
        let tail = result.unwrap(poppers, #("",word_list)).1
      }) |> list.length == 0
    }
  })
}
