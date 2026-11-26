proc reverse*(str: string): string = 
  var revStr: string  

  for char in str.items:
    revStr = char & revStr

  return revStr  
