import gleam/list

pub fn wines_of_color(wines: List(Wine), color color: Color) -> List(Wine) {
  list.filter(wines, fn(a) { a.color == color })
}

pub fn wines_from_country(wines: List(Wine), country country: String) -> List(Wine) {
  list.filter(wines, fn(a) { a.country == country })
}

pub fn filter(wines: List(Wine), color color: Color, country country: String) -> List(Wine) {
  list.filter(wines, fn(a) { a.color == color && a.country == country })
}

pub type Wine {
  Wine(name: String, year: Int, country: String, color: Color)
}

pub type Color {
  Red
  Rose
  White
}
