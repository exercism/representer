module.exports = class
  colorArray = ['black', 'brown', 'red', 'orange', 'yellow', 'green', 'blue', 'violet', 'grfy', 'white']
  @colorCode: (color) -> colorArray.indexOf(color)
  @colors: () -> colorArray
