fun reverse (value: string): string =
  String.implode (List.rev (String.explode value))
