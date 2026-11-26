class BeerSong {
  static recite(start, count) {
    return (start...(start - count)).reduce([]) { |song, n|
      if (n != start) song.add("")
      song.addAll(verse(n))
      return song
    }
  }

  static verse(n) {
    if (n == 0) {
      return [
        "No more bottles of beer on the wall, no more bottles of beer.",
        "Go to the store and buy some more, 99 bottles of beer on the wall.",
      ]
    } else if (n == 1) {
      return [
        "1 bottle of beer on the wall, 1 bottle of beer.",
        "Take it down and pass it around, no more bottles of beer on the wall.",
      ]
    } else if(n == 2) {
      return [
        "2 bottles of beer on the wall, 2 bottles of beer.",
        "Take one down and pass it around, 1 bottle of beer on the wall.",
      ]
    } else {
      return [
        "%(n) bottles of beer on the wall, %(n) bottles of beer.",
        "Take one down and pass it around, %(n - 1) bottles of beer on the wall.",
      ]
    }
  }
}
