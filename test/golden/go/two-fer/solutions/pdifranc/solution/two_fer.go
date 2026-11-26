package twofer

func ShareWith(name string) string {
	return "One for " + ComputeName(name) + ", one for me."
}

func ComputeName(name string) string{
  if len(name) == 0 {
    return "you"
  }
  return name
}