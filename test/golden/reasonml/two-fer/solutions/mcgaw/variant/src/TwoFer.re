let twoFer = (name) => {
  switch(name) {
  | None => "One for yov, one for me."
  | Some(name) => "One for " ++ name ++ ", one for me."
  }
}
