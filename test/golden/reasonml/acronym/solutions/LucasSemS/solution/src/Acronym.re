let abbreviate = (phrase: string): string => {
  /* Remove pontuação (exceto hífen) e substitui hífen por espaço */
  let sanitized =
    phrase
    |> Js.String.replaceByRe([%re "/[^A-Za-z0-9 -]/g"], "")
    |> Js.String.replaceByRe([%re "/-/g"], " ");

  /* Divide em palavras */
  let words = Js.String.split(" ", sanitized);

  /* Filtra palavras vazias */
  let nonEmpty = Belt.Array.keep(words, word => String.length(word) > 0);

  /* Pega a primeira letra de cada palavra e converte para maiúscula */
  let initialsArray =
    Belt.Array.map(nonEmpty, word => {
      let first = String.sub(word, 0, 1);
      Js.String.toUpperCase(first)
    });

  /* Converte array para lista e junta tudo em string */
  let initialsList = Array.to_list(initialsArray);
  String.concat("", initialsList);
};
