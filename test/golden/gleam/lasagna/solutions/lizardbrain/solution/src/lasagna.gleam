// Please define the expected_minutes_in_oven function
pub fn expected_minutes_in_oven(){
    let time : Int = 40
    time
}
// Please define the remaining_minutes_in_oven function

pub fn remaining_minutes_in_oven(time : Int) {
  let output : Int = expected_minutes_in_oven() - time
  output
}

// Please define the preparation_time_in_minutes function

pub fn preparation_time_in_minutes(layers : Int){
  layers * 2
}

// Please define the total_time_in_minutes function

pub fn total_time_in_minutes(layers : Int, time : Int) {
    let output : Int = preparation_time_in_minutes(layers) + time
    output
}

// Please define the alarm function
pub fn alarm(){
  "Ding!"
}
