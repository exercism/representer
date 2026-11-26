//
// This is only a SKELETON file for the 'Secret Handshake' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

const ACTION=[
  'wink',
  'double blink',
  'close your eyes',
  'jump'];

export const commands = (num) => {
  return num & 17 ? preCommands(num).reverse() : preCommands(num);
};

function preCommands(num){
  return ACTION.filter((action,it) => (1<<it)&num );
}