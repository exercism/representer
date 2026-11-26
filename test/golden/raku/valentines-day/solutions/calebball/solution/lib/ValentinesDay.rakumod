unit module ValentinesDay;

enum Answer is export (Yes => True, No => False);

# You may use enums, subsets, classes, or roles as you see fit.
class  Chill       is export {}
enum   Restaurant  is export ('Korean','Turkish');
enum   Movie       is export ('Crime','Horror','Romance');
enum   Game        is export ('Chess','TicTacToe','GlobalThermonuclearWar');
subset Walk of Num is export where all(* > 0, * < Inf);

subset Activity is export where * ~~ any(Chill, Restaurant, Movie, Game, Walk);

multi rate-activity ( Chill --> Answer ) is export {
  No
}

multi rate-activity ( Restaurant $cuisine --> Answer ) is export {
  given $cuisine {
    when 'Korean' { Yes }
    when 'Turkish' { Answer }
  }
}

multi rate-activity ( Movie $genre --> Answer ) is export {
  given $genre {
    when 'Crime' { No }
    when 'Horror' { No }
    when 'Romance' { Yes }
  }
}

multi rate-activity ( Game $game --> Answer ) is export {
  given $game {
    when 'Chess' { Yes }
    when 'TicTacToe' { Answer }
    when 'GlobalThermonuclearWar' { No }
  }
}

multi rate-activity ( Walk $length --> Answer ) is export {
  given $length {
    when * < 1 { Yes }
    when * < 15 { Answer }
    default { No }
  }
}
