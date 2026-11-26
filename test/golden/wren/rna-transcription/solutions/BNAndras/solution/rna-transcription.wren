var COMPLEMENT = {
  "A": "U", 
  "G": "C", 
  "C": "G", 
  "T": "A"
} 

class DNA {
  static toRNA(strand) {
    return strand.map { |nuc| COMPLEMENT[nuc] }.join()
  }
}