class ResistorColorDuo
  @colorMap =
    black: 0
    brown: 1
    red: 2
    orange: 3
    yellow: 4
    green: 5
    blue: 6
    violet: 7
    grey: 8
    white: 9

  @value: (colors) ->
    10 * @colorMap[colors[0]] + @colorMap[colors[1]]

module.exports = ResistorColorDuo
