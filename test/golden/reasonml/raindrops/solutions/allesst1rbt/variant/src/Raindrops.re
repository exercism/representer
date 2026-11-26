let modby = (number,factor)=> number mod factor != 0 ? true : false

let raindrops: int => string = (rain:int) => switch  (modby(rain,3),modby(rain,5),modby(rain,7)) {
    | (true,true,true) => "PlingPlangPlong"
    | (true,true,_)    => "PlingPlang"
    | (true,_,true)    => "PlingPlong"
    | (_,true,true)    => "PlangPlong"
    | (true,_,_)       => "Pling"
    | (_,true,_)       => "Plang"
    | (_,_,true)       => "Plong"
    | (_,_,_)       => string_of_int(rain)
};

