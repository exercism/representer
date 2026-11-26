class ProteinTranslation {
  Map rnaMap = {
    "AUG": "Methionine",
    "UUU": "Phenylalanine",
    "UUC": "Phenylalanine",
    "UUA": "Leucine",
    "UUG": "Leucine",
    "UCU": "Serine",
    "UCC": "Serine",
    "UCA": "Serine",
    "UCG": "Serine",
    "UAU": "Tyrosine",
    "UAC": "Tyrosine",
    "UGU": "Cysteine",
    "UGC": "Cysteine",
    "UGG": "Tryptophan",
    "UAA": "STOP",
    "UAG": "STOP",
    "UGA": "STOP"
  };

  List<String> translate(String input) {
    List<String> resultList = [];
    var splitList = splitInput(input);
    splitList.forEach((element) {
      if (rnaMap.containsKey(element)) {
        resultList.add(rnaMap[element]);
      }
    });

    if (resultList.isNotEmpty) {
      if (input.length % 3 == 0) {
        return resultList.contains("STOP")
            ? resultList.sublist(0, resultList.indexOf("STOP"))
            : resultList;
      } else {
        return resultList.contains("STOP")
            ? resultList.sublist(0, resultList.indexOf("STOP"))
            : throw ArgumentError();
      }
    } else {
      return input == "" ? resultList : throw ArgumentError();
    }
  }

  List<String> splitInput(String input) {
    List<String> result = [];
    for (int i = 0; i < input.length; i += 3) {
      if ((i + 3) <= input.length) {
        result.add(input.substring(i, i + 3));
      } else {
        result.add(input.substring(i, input.length));
      }
    }
    return result;
  }
}