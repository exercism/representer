let classify nb = 
  if nb <= 0 then
    Error "Classification is only possible for positive integers."
  else if nb = 1 then
    Ok "deficient"
  else
    let somme = ref (-nb) in
    let i = ref 1 in
    while !i * !i < nb do
      if nb mod !i = 0 then
        if !i * !i = nb then
          somme := !somme + !i
        else
          somme := !somme + !i + nb / !i;
      i := !i + 1
    done;
    if !somme = nb then Ok "perfect"
    else if !somme > nb then Ok "abundant"
    else Ok "deficient"
;;