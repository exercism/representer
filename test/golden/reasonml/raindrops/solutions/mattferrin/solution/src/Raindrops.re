let raindrops = input => {
  let pling = input mod 3 == 0 ? "Pling" : "";
  let plang = input mod 5 == 0 ? "Plang" : "";
  let plong = input mod 7 == 0 ? "Plong" : "";

  let plingPlangPong = {j|$pling$plang$plong|j};
  plingPlangPong == "" ? string_of_int(input) : plingPlangPong;
};

/* Alternative solution: */
/* switch ([input mod 3, input mod 5, input mod 7]) {
   | [0, 0, 0] => "PlingPlangPlong"
   | [_, 0, 0] => "PlangPlong"
   | [0, _, 0] => "PlingPlong"
   | [0, 0, _] => "PlingPlang"
   | [0, _, _] => "Pling"
   | [_, 0, _] => "Plang"
   | [_, _, 0] => "Plong"
   | _ => string_of_int(input)
   }; */