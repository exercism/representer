var NUC={"A":"U", "C":"G", "G":"C", "T":"A"}
class DNA {
  static toRNA(strand) {
    var rna=""
    for (base in strand) {
      rna=rna+NUC[base]
    }
    return rna
  }
}
