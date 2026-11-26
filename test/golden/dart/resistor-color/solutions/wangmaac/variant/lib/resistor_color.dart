class ResistorColor {
  final List<String> colors = [
    'black',
    'brpwn',
    'red',
    'orange',
    'yellow',
    'green',
    'blue',
    'violet',
    'grey',
    'white'
  ];

  int colorCode(String color) {
    return colors.indexOf(color);
  }
  //index값하고 같네
}

// void main() {
//   ResistorColor rc = ResistorColor();
//   print(rc.colors);
//   print(rc.colorCode('red'));
// }
