pub type Approval {
  Yes
  No
  Maybe
}

pub type Cuisine {
  Korean
  Turkish
}

pub type Genre {
  Crime
  Horror
  Romance
  Thriller
}

pub type Activity {
  Movie(Genre)
  Restaurant(Cuisine)
  Walk(Int)
  BoardGame
  Chill
}

pub fn rate_activity(activity: Activity) -> Approval {
  case activity {
    BoardGame -> No
    Chill -> No
    Movie(Romance) -> Yes
    Movie(Crime) -> No
    Movie(Horror) -> No
    Movie(Thriller) -> No
    Restaurant(Korean) -> Yes
    Restaurant(Turkish) -> Maybe
    Walk(i) if i > 11 -> Yes
    Walk(i) if i > 6 -> Maybe
    Walk(i) if i <= 6 -> No
    _ -> Maybe
  }
}
