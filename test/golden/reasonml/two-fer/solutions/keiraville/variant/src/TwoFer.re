let twoFer = name =>
  switch (name) {
  | None => "One for yov, one for me."
  | Some(n) => "One for " ++ n ++ ", one for me."
  };
