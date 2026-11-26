class BeerSong {
  static recite(a, b) {
	var lyrics = []
	lyrics = recite(a, b, lyrics)
	lyrics.removeAt(lyrics.count - 1)
	return lyrics
  }
  
  static recite(a, b, lyrics){
	var s = ""
	var it_one = "one"
	var how_many = ""
	if(a - 1 >= 1){
		s = "s"
	}else{
        s = ""
    }
	if(a - 1 > 1){	
		how_many = "%(a - 1) bottle%(s)"
	}else if(a - 1 == 1){
		how_many = "%(a - 1) bottle"
	}
	if(a - 1 < 1){
		how_many = "no more bottles"
        it_one = "it"
	}
	if(a == 0){
		lyrics.add("No more bottles of beer on the wall, no more bottles of beer.")
		lyrics.add("Go to the store and buy some more, 99 bottles of beer on the wall.")
		lyrics.add("")		
	}else{
		lyrics.add("%(a) bottle%(s) of beer on the wall, %(a) bottle%(s) of beer.")
		lyrics.add("Take %(it_one) down and pass it around, %(how_many) of beer on the wall.")
		lyrics.add("")
	}
	if(b > 1){
		lyrics = recite(a - 1, b - 1, lyrics) 
	}
	return lyrics
  }
}