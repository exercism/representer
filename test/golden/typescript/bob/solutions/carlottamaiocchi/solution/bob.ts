export function hey(messages: string): string {
  let message = messages.trimRight()
  console.log(message);
  var regExp = /[a-zA-Z]/g;
  if(message && regExp.test(message)){
    if(message.charAt(message.length - 1) == "?" && message.toUpperCase() != message){
      return "Sure.";
    } else if(message.toUpperCase() == message && message.charAt(message.length - 1) != "?"){
      return 'Whoa, chill out!' ;
    } else if(message.charAt(message.length - 1) == "?" && message.toUpperCase() === message){
      return "Calm down, I know what I'm doing!";
    } else if(message.length === 0){
      return 'Fine. Be that way!';
    } else return 'Whatever.';
  }

  if(message && !regExp.test(message)){
    if(message.charAt(message.length - 1) == "?"){
      return 'Sure.';
    } else if(message === '   '){
      return 'Fine. Be that way!';
    } else if(message === '\t\t\t\t\t\t\t\t\t\t' || message === '\n\r \t'){
      return 'Fine. Be that way!';
    }else return "Whatever."
  };

  if(message === '') {
    return 'Fine. Be that way!';
  };

  throw new Error("Shouldn't be reachable");
}


