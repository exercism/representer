class Triangle {
  construct new(a, b, c) {
   var vertex = 0
   _vertex = 0
    if(a == b) { 
     vertex = vertex + 1
    }
    if(b == c) { 
    vertex = vertex + 1
    }
    if(a == c) { 
    vertex = vertex + 1
    }
    if((a+b>=c) && (b+c>=a) && (a+c>=b) && (a+b+c != 0)){
		_vertex = vertex
    }else{
		_vertex = -1
    }
    
  }

  isEquilateral {
    if(_vertex == 3){
		return true
    }else{
		return false
    }
  }

  isIsosceles {
    if(_vertex == 1 || _vertex == 3){
		return true
    }else{
		return false
    }    
  }

  isScalene {
    if(_vertex != 1 && _vertex != 3 && _vertex == 0){
		return true
    }else{
        return false
    }
  }
}