datatype allergen = Eggs
                  | Peanuts
                  | Shellfish
                  | Strawberries
                  | Tomatoes
                  | Chocolate
                  | Pollen
                  | Cats

fun dec2bin (x: int): int list =
	if x <= 1
		then [x]
	else  
		 [(x mod 2)] @ dec2bin (x div 2);

fun add_index l =
  let 
    fun add_index_helper (nil,  _) = nil
      | add_index_helper (h::tl,i) = (h,i) :: add_index_helper (tl,1+i)
  in
     add_index_helper (l,0)
  end

fun getfirst(a:int, b:int) = a;

fun getsecond(a:int, b:int) = b;

fun mapPositionToAllergen (x: int) = 
    case x of
      7 => Cats
    | 6 => Pollen
    | 5 => Chocolate
    | 4 => Tomatoes
    | 3 => Strawberries
    | 2 => Shellfish
    | 1 => Peanuts
    | _ => Eggs;

fun getOneEntries l =
  List.filter(fn e => getfirst(e) = 1) (add_index l)

fun removeEightPlus l =
  List.filter(fn e => getsecond(e) < 8) l 

fun allergies (score: int): allergen list =
  List.map(fn e => mapPositionToAllergen(getsecond e)) 
    (removeEightPlus(getOneEntries(dec2bin(score))))

fun allergicTo (score: int) (a: allergen): bool =
  List.exists(fn e => a = e) (allergies(score))