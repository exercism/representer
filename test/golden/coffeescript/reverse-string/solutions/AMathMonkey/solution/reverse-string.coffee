class ReverseString  
  @reverse: (str) -> (str[i] for i in [str.length - 1 .. 0]).join('')

module.exports = ReverseString
