class ResistorColorDuo {
  var colors = [
    'black',
    'brown',
    'red',
    'orange',
    'yellow',
    'green',
    'blue',
    'viomet',
    'grey',
    'white',
  ];

  int value(List<String> colorPair) => int.parse(
    '${colors.indexOf(colorPair[0])}${colors.indexOf(colorPair[1])}'
  );
}
