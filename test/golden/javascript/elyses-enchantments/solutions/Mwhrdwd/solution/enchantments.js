export const getItem = (array, position) => {
  return array[position];
};

export const setItem = (array, position, replacementCard) => {
  array[position] = replacementCard;
  return array;
};

export const insertItemAtTop = (array, newCard) => {
  array.push(newCard);
  return array;
};

export const removeItem = (array, position) => {
  array.splice(position, 1);
  return array;
};

export const removeItemFromTop = (array) => {
  array.pop();
  return array;
};

export const insertItemAtBottom = (array, newCard) => {
  array.unshift(newCard);
  return array;
};

export const removeItemAtBottom = (array) => {
  array.shift();
  return array;
};

export const checkSizeOfStack = (array, stackSize) => {
  return array.length == stackSize ? true : false;
};
