import gleam/list

pub fn new_list() -> List(String) {
  []
}

pub fn existing_list() -> List(String) {
  ["Gleam", "Go", "TypeScript"]
}

pub fn add_language(languages: List(String), language: String) -> List(String) {
  [language, ..languages]
}

pub fn count_languages(languages: List(String)) -> Int {
  case languages {
    [_, ..rest] -> count_languages(rest) - 1
    [] -> 0
  }
}

pub fn reverse_list(languages: List(String)) -> List(String) {
  case languages {
    [] -> []
    [x, ..rest] -> list.append(reverse_list(rest), [x])
  }
}

pub fn exciting_list(languages: List(String)) -> Bool {
  case languages {
    ["Gleam", ..] -> True
    [_, "Gleam", ..] -> case count_languages(languages) {
      2 | 3 -> True
      _ -> False
    }
    _ -> False
  }
}
