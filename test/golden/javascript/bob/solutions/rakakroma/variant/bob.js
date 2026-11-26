//
// This is only a SKELETON file for the 'Bob' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export const hey = (message) => {
  const trimMessage = message.trim();
  return  trimMessage[trimMessage.length-1] === '?' && trimMessage.toUpperCase() === trimMessage && /[a-z]/i.test(trimMessage) ? `Calm down, I know what I'm doing!` :
         trimMessage[trimMessage.length-1] === '?' ? 'Sure.' : 
         trimMessage === ""? 'Fine. Be that way!' :
         trimMessage.toUpperCase() === trimMessage || /[a-z]/i.test(trimMessage)? 'Whoa, chill out!' : 'Whatever.';
         
};
