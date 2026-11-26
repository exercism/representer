namespace Grep

def parseArgs (args : List String) : Option (String × List String × List String) :=
  match args with
  | [] => none
  | pattern :: rest =>
    let flags := rest.filter (fun s => s.startsWith "-")
    let files := rest.filter (fun s => !s.startsWith "-")
    some (pattern, flags, files)

/-- Compute the prefix for a matching line. -/
def linePrefix (filename : String) (lineNum : Nat)
    (multiFile : Bool) (showLineNumbers : Bool) : String :=
  if multiFile && showLineNumbers then
    filename ++ ":" ++ toString lineNum ++ ":"
  else if multiFile then
    filename ++ ":"
  else if showLineNumbers then
    toString lineNum ++ ":"
  else
    ""

def processFile (pattern : String) (flags : List String) (filename : String)
    (contents : String) (multiFile : Bool) : List String :=
  let caseInsensitive := flags.contains "-i"
  let invert := flags.contains "-v"
  let entireLine := flags.contains "-x"
  let showLineNumbers := flags.contains "-n"
  let showFilenames := flags.contains "-l"
  let lines := contents.splitOn "\n"
  let lines := if lines.getLast? == some "" then lines.dropLast else lines
  let matchesLine (line : String) : Bool :=
    let pat := if caseInsensitive then pattern.toLower else pattern
    let l := if caseInsensitive then line.toLower else line
    let hit := if entireLine then l == pat else l.contains pat
    if invert then !hit else hit
  let matched := lines.zipIdx.filter (fun (line, _) => matchesLine line)
  if showFilenames then
    if matched.isEmpty then [] else [filename]
  else
    matched.map fun (line, idx) =>
      linePrefix filename (idx - 1) multiFile showLineNumbers ++ line

def grep (args : List String) : IO Unit := do
  match parseArgs args with
  | none =>
    IO.println "Called without arguments"
  | some (pattern, flags, files) =>
    if files.isEmpty then
      IO.println "Called without a file name"
    else
      let multiFile := files.length > 1
      let mut output : List String := []
      let mut errorOccurred := false
      for filename in files do
        try
          let contents ← IO.FS.readFile filename
          let result := processFile pattern flags filename contents multiFile
          output := output ++ result
        catch _ =>
          errorOccurred := true
      if errorOccurred then
        IO.println "File not found"
      else
        for line in output do
          IO.println line

end Grep