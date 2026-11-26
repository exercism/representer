/**
* Your implmentation of the Triangle exercise
*/
component {

	/**
	* @returns 
	*/
	function equilateral( array sides ) {
		if(not isTriangle(sides)) return false;

		if(identicalSides(sides) gt 1) return true;
		return false;
	}
	
	function isosceles( array sides ) {
		if(not isTriangle(sides)) return false;

		if(identicalSides(sides) gt 0) return true;
		return false;
	}
	
	function scalene( array sides ) {
		if(not isTriangle(sides)) return false;

		if(identicalSides(sides) eq 0 ) return true;
		return false;
	}

	function degenerate( array sides ) {
		if(not isTriangle(sides)) return false;

		var a = sides[1];
		var b = sides[2];
		var c = sides[3];

		if(a+b eq c) return true;
		if(a+c eq b) return true;
		if(b+c eq a) return true;

		return false;
	}
	
	private function isTriangle(sides){
		// if all sides are zero, not a triangle
		if(sides.sum() eq 0) return false;
		// has 3 sides?
		if(sides.len() neq 3) return false;
		// sum of two sides must be greater than 3rd side
		var a = sides[1];
		var b = sides[2];
		var c = sides[3];
		if(a+b lt c) return false;
		if(a+c lt b) return false;
		if(b+c lt a) return false;
		// its a triangle!
		return true;
	}

	private function identicalSides(sides){
		var a = sides[1];
		var b = sides[2];
		var c = sides[3];

		var identicalSides = 0;

		if(a == b) identicalSides++;
		if(a == c) identicalSides++;
		if(b == c) identicalSides++;

		return identicalSides;
	}
}