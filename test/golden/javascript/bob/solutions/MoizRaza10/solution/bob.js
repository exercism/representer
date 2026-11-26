//
// This is only a SKELETON file for the 'Bob' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export const hey = (message) => {
  let regex = /[a-zA-Z]/;
  message=message.trim();
  if(message.toUpperCase()==message && regex.test(message)){
    if(message.endsWith("?")){
      return `Calm down, I know what I'm doing!`;
    }else{
      return `Whoa, chill out!`
    }
  }else if(message.endsWith("?")){
    return "Sure."
  }else if(message==""){
    return "Fine. Be that way!"
  }else{
    return "Whatever."
  }
};
