import gleam/option.{type Option}

pub fn two_fer(name: Option(String)) -> String {
  let name = name |> option.unwrap("you")
  "One for " <> name <> ", one for me."
}