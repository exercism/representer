let phoneNumber = (input: string): option(string) => {
  let sanitised = Js.String.replaceByRe([%re "/[@:!()-. +a-z]/g"], "", input);

  switch (sanitised) {
  | n when String.length(n) == 10 && n.[0] != '0' && n.[0] != '1' => Some(n)
  | n
      when
        String.length(n) == 11 && n.[0] == '1' && n.[1] != '0' && n.[1] != '1' =>
    Some(String.sub(n, 1, 10))
  | _ => None
  };
};
