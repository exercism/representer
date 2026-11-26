{
  abbreviate: (phrase) ->
    phrase\gsub("'", "")\gsub("(%a)%a*", "%1")\gsub("[^%a]", "")\lower!
}
