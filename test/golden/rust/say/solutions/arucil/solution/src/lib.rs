
pub fn encode(mut n: u64) -> String {
  let mut chunks = vec![];
  while n > 0 {
    chunks.push(n % 1000);
    n /= 1000;
  }
  if chunks.is_empty() {
    return "zero".to_owned();
  }

  let small_numbers = [ "", "one", "two", "three", "four", "five", "six",
    "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen",
    "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"];

  let ten_scales = ["twenty", "thirty", "forty", "fifty", "sixty",
    "seventy", "eighty", "ninety"];

  let scales = ["thousand", "million", "billion", "trillion", "quadrillion",
    "quintillion"];

  let mut chunks: Vec<_> = chunks.iter().map(|&chunk| {
    let tens = chunk % 100;
    let tens = small_numbers.get(tens as usize).map(|&s| s.to_owned()).unwrap_or_else(|| {
      let scale = ten_scales[(tens / 10 - 2) as usize];
      if tens % 10 == 0 {
        scale.to_owned()
      } else {
        format!("{}-{}", scale, small_numbers[(tens % 10) as usize])
      }
    });
    let mut res = vec![];
    if chunk > 99 {
      res.push(format!("{} hundred", small_numbers[(chunk / 100) as usize]));
    }
    if !tens.is_empty() {
      res.push(tens);
    }
    res.join(" ")
  }).collect();

  let mut i = 1;
  let mut scale_ix = 0;
  while i < chunks.len() {
    if !chunks[i].is_empty() {
      chunks.insert(i, scales[scale_ix].to_owned());
      i += 1;
    }
    i += 1;
    scale_ix += 1;
  }
  
  chunks.into_iter().rev().filter(|s| !s.is_empty()).collect::<Vec<_>>().join(" ")
}
