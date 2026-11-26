class Darts {
  static score(x,y) {
    var radius = (x * x + y * y).sqrt
    if(radius > 10){
		return 0
    }else if (radius > 5){
		return 1
    }else if (radius > 1){
		return 5
    }else{
		return 10
    }
  }
}
