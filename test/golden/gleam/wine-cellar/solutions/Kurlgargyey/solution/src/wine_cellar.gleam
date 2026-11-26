import gleam/list

pub fn wines_of_color(in wines: List(Wine), of color: Color) -> List(Wine) {
  wines
  |> list.filter(fn(w){w.color == color})
}

pub fn wines_from_country(in wines: List(Wine), from country: String) -> List(Wine) {
  wines
  |> list.filter(fn(w){w.country == country})
}

// Please define the required labelled arguments for this function
pub fn filter(wines wines: List(Wine), color color: Color, country country: String) -> List(Wine) {
  wines
  |> wines_of_color(color)
  |> wines_from_country(country)
}

pub type Wine {
  Wine(name: String, year: Int, country: String, color: Color)
}

pub type Color {
  Red
  Rose
  White
}
