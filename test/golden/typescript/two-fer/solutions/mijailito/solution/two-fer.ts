/**
 * This stub is provided to make it straightforward to get started.
 */

 export function twoFer(name:string): string {
     let mensaje
    if (name === undefined){
      mensaje= "One for you, one for me."
    }
    else
    {
      mensaje = "One for "+name+", one for me."
    }
    
    return mensaje;
    
  }
  twoFer("");