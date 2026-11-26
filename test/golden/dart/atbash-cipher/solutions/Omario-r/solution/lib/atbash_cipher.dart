class AtbashCipher {
  final plain = 'abcdefghijklmnopqrstuvwxyz';
  final cipher = 'zyxwvutsrqponmlkjihgfedcba';

  String getOppositeSymbol(String symbol, String source, String target) {
    final isLetter = source.contains(symbol.toLowerCase());
    final isNumber = int.tryParse(symbol) != null;                             
    if (!isLetter && !isNumber) {
      return '';
    }
    
    final index = source.indexOf(symbol.toLowerCase());
    
    return index < 0 ? symbol : target[index];
  }
  
  String splitByGroup(String string, int symbolNumberInGroup) {
    var currentGroup = '';
    final almostDone = string.split('').fold('', (splitted, symbol) {
      if (currentGroup.length < symbolNumberInGroup) {
        currentGroup += symbol;
        
        return splitted;
      }
      
      final newSplitted = splitted + currentGroup + ' ';
      currentGroup = symbol;
      
      return newSplitted;
    });
    
    return almostDone.length >= symbolNumberInGroup ? almostDone + currentGroup : currentGroup;
  }
  
  String encode(String phrase) {
    final encoded = phrase.split('')
      .fold('', (encodedPhrase, symbol) => encodedPhrase + this.getOppositeSymbol(symbol, this.plain, this.cipher));
    
    return this.splitByGroup(encoded, 5);
  }

  String decode(String phrase) {
    return phrase.split('')
      .fold('', (encodedPhrase, symbol) => encodedPhrase + this.getOppositeSymbol(symbol, this.cipher, this.plain));
  }
}
