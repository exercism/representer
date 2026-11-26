module main

fn truncate(phrase string) string {
  mut runes := phrase.runes()
  runes.trim(5)
  return runes.string()
}
