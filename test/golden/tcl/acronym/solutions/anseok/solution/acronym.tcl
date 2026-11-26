proc abbreviate phrase { string toupper [string cat {*}[
  lmap w [regsub -all {[-_]} $phrase " "] { string index $w 0 }]] }
