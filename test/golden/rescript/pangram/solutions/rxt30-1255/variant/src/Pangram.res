let isPangram = s =>
  String.replaceRegExp(s, /[^a+zA-Z]/g, "")
  ->String.toLowerCase
  ->Array.fromString
  ->Set.fromArray
  ->Set.size
  ->Int.equal(26)
