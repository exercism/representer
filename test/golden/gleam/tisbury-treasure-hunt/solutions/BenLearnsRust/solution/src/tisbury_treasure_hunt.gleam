//// For the kids at home, don't pass around stuff in tuples like this. 
//// Naming things is rad.

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
  place_location
  |> place_location_to_treasure_location == treasure_location
}

pub fn count_place_treasures(
  place: #(String, #(String, Int)),
  treasures: List(#(String, #(Int, String))),
) -> Int {
  let #(_, place_location) = place
  let treasure_location =
    place_location
    |> place_location_to_treasure_location
  list.filter(treasures, fn(treasure) { treasure.1 == treasure_location })
  |> list.length
}

pub fn special_case_swap_possible(
  found_treasure: #(String, #(Int, String)),
  place: #(String, #(String, Int)),
  desired_treasure: #(String, #(Int, String)),
) -> Bool {
  case found_treasure.0, place.0, desired_treasure.0 {
    // The Brass Spyglass can be swapped for any other 
    // treasure at the Abandoned Lighthouse.
    "Brass Spyglass", "Abandoned Lighthouse", _ -> True

    // The Amethyst Octopus can be swapped for the 
    // Crystal Crab or the Glass Starfish at the Stormy Breakwater.
    "Amethyst Octopus", "Stormy Breakwater", "Crystal Crab"
    | "Amethyst Octopus", "Stormy Breakwater", "Glass Starfish" -> True

    // The Vintage Pirate Hat can be swapped for the Model Ship 
    // in Large Bottle or the Antique Glass Fishnet Float at the
    // Harbor Managers Office
    "Vintage Pirate Hat", "Harbor Managers Office", "Model Ship in Large Bottle"
    | "Vintage Pirate Hat", "Harbor Managers Office", "Antique Glass Fishnet Float" ->
      True

    _, _, _ -> False
  }
}
