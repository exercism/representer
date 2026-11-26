syntax "register_colors " "[" (ident ":=" num),* "]" : command

macro_rules
  | `(register_colors [ $[$names := $vals],* ]) => do
    let mut rules := #[]
    for (id, val) in names.zip vals do
      let rule ← `(macro_rules | `(c*$id) => `(($val : Fin 10)))
      rules := rules.push rule

    let all_rules ← `(macro_rules | `(c*all) => `(#[$[c*$names],*]))
    rules := rules.push all_rules

    pure $ Lean.Syntax.node Lean.SourceInfo.none `null rules

register_colors [
  black  := 0,
  brown  := 1,
  red    := 2,
  orange := 3,
  yellow := 4,
  green  := 5,
  blue   := 6,
  violet := 7,
  grey   := 8,
  white  := 9
]
