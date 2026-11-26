class DNA {
  static toRNA(strand) {
    var dna = strand
    var rna = ""
    
    for (el in dna){
      if (el == "T"){
        rna = rna + "A"
      }else if(el == "C"){
        rna = rna + "G"
      }else if (el == "A"){
        rna = rna + "U"
      }else if (el == "G"){
        rna = rna + "C"
      }
    }
    return(rna)
  }
}
