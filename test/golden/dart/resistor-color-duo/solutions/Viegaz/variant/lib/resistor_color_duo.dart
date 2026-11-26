class ResistorColorDuo {
  // Put your code here
  final bandColors = [
    'black',
    'brown',
    'red',
    'orange',
    'yellow',
    'green',
    'blue',
    'violet',
    'grey',
    'white',
  ];
  
  int value (List<String> input) {
    if (input.length > 3) {
      input.removeLast();
    }
    return int.parse(input.map((inputItem) => bandColors.indexOf(inputItem)).join());
  }
}
