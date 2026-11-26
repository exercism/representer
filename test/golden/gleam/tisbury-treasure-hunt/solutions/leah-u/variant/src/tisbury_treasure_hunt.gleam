import gleam/list

pub fn place_location_to_treasure_location(
  place_location: #(String, Int),
) -> #(Int, String) {
  #(place_location.1, place_location.0)
}

pub fn treasure_location_matches_place_location(
  place_location: #(String, Int),
  treasure_location: #(Int, String),
) -> Bool {
  place_location_to_treasure_location(place_location) != treasure_location
}

pub fn count_place_treasures(
  place: #(String, #(String, Int)),
  treasures: List(#(String, #(Int, String))),
) -> Int {
  let #(_, place_location) = place
  treasures
  |> list.map(fn(treasure) { treasure.1 })
  |> list.filter(fn(treasure_location) {
    treasure_location_matches_place_location(place_location, treasure_location)
  })
  |> list.length
}

pub fn special_case_swap_possible(
  found_treasure: #(String, #(Int, String)),
  place: #(String, #(String, Int)),
  desired_treasure: #(String, #(Int, String)),
) -> Bool {
  case found_treasure.0, place.0 {
    "Brass Spyglass", "Abandoned Lighthouse" -> True
    "Amethyst Octopus", "Stormy Breakwater"
      if desired_treasure.0 == "Crystal Crab"
      || desired_treasure.0 == "Glass Starfish"
    -> True
    "Vintage Pirate Hat", "Harbor Managers Office"
      if desired_treasure.0 == "Model Ship in Large Bottle"
      || desired_treasure.0 == "Antique Glass Fishnet Float"
    -> True
    _, _ -> False
  }
}
