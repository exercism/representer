export const ALFABETO  :  string[]  =  [
  'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'
]

export function isPangram(string:string):boolean {
  let strings = string.toLowerCase();
  if(strings.indexOf( '.') > -1){
    ALFABETO.push('.');
    console.log(ALFABETO) 
  };
  if(strings.indexOf( '"') > -1){
    ALFABETO.push('"');
    console.log(ALFABETO) 
  }
  for(let i=0;i<ALFABETO.length; i++){
    if(strings.indexOf(ALFABETO[i]) != -1){
      
    } else return false;
  }
  return true;
}
