function flag(name) { return !!index(flags, name) }
BEGIN { IGNORECASE = flag("i"); if (flag("x")) pattern = "^(" pattern ")$" }
BEGINFILE { found = 0 }
($0 ~ pattern) != flag("v") {
  found = 1
  if (!flag("l"))
    print (ARGC > 2 ? FILENAME ":" : "") (flag("n") ? FNR ":" : "") $0
}
ENDFILE { success += found; if (flag("l") && found) print FILENAME }
END { exit !success }
