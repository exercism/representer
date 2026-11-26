import gleam/list
import gleam/string

pub fn recite(start_verse start_verse: Int, end_verse end_verse: Int) -> String {
  list.range(start_verse, end_verse)
  |> list.map(verse)
  |> string.join("\n")
}

fn verse(id: Int) -> String {
  let the_list = [
    #("house", "Jack built"),
    #("malt", "lay in"),
    #("rat", "ate"),
    #("cat", "killed"),
    #("dog", "worried"),
    #("cow with the crumpled horn", "tossed"),
    #("maiden all forlorn", "milked"),
    #("man all tattered and torn", "kissed"),
    #("priest all shaven and shorn", "married"),
    #("rooster that crowed in the morn", "woke"),
    #("farmer sowing his corn", "kept"),
    #("horse and the hound and the horn", "belonged to"),
  ]
  let compose = fn(t: #(String, String)) { "the " <> t.0 <> " that " <> t.1 }
  let middle =
    the_list
    |> list.take(id)
    |> list.reverse
    |> list.map(compose)
    |> string.join(" ")
  "This is " <> middle <> "."
}
