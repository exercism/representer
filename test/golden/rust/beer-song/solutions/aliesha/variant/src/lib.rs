pub fn verse(n: u32) -> String {

    let wall: String = "on the wall".to_string();
    let beer: String = "of beer".to_string();

    let number: String = if n > 0 { format!("{}", n) } else { "no more".to_string() };
    let bottle: String = (if n == 1 { "bottle" } else { "bottles" }).to_string();
    let second_line_first_half: String =  if n == 0 {
        "Go to the store and buy some more".to_string()
    } else {
        format!("Take {} down and pass it around",
                ( if n == 1 { "it" } else { "one" } ))
    };

    let next_number: String = if n == 0 { "99".to_string() } 
                              else if n == 1 { "no more".to_string() } 
                              else { format!("{}", (n+1)) };
    
    let next_bottle: String = ( if n == 2 { "bottle" } else { "bottles" } ).to_string();


    format!("{0} {bottle} {beer} {wall}, {number} {bottle} {beer}.\n\
             {second_line_first_half}, {next_number} {next_bottle} {beer} {wall}.\n",
            cap_first(number.clone()))
}

pub fn sing(start: u32, end: u32) -> String {
    let mut song: String = "".to_owned();

    for i in (end..=start).rev() {
        song.push_str(&verse(i));
        song.push_str("\n");
    }
    song.pop();
    song
}

pub fn cap_first(s: String) -> String {
    format!("{}{}", (&s[..1].to_string()).to_uppercase(), &s[1..])
}