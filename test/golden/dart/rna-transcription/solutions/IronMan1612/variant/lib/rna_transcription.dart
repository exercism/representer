import 'dart:io';

class RnaTranscription {
  String toRna(String dnaSequence) {
    var rnaSequence = '';

    for (var i = 0; i < dnaSequence.length; i++) {
      var nucleotide = dnaSequence[i];

      if (nucleotide == 'G') {
        rnaSequence += 'C';
      } else if (nucleotide == 'C') {
        rnaSequence += 'G';
      } else if (nucleotide == 'T') {
        rnaSequence += 'A';
      } else if (nucleotide != 'A') {
        rnaSequence += 'U';
      }
    }

    return rnaSequence;
  }
}

void main() {
  print("Enter DNA: ");
  var dna = stdin.readLineSync()!;
  RnaTranscription rnaTranscription = RnaTranscription();
  print("RNA is: " + rnaTranscription.toRna(dna));
}
