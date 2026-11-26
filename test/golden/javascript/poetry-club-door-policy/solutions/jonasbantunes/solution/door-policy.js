//@ts-check

/**
 * @param {string} poemLine
 * @returns string
 */
export const frontDoorResponse = (poemLine) => {
  return poemLine[0];
};

/**
 * @param {string} password
 * @returns string
 */
export const frontDoorPassword = (password) => {
  const firstChar = password[0].toUpperCase();
  const remaining = password.substring(1).toLowerCase();
  return firstChar + remaining;
};

/**
 * @param {string} poemLine
 * @returns string
 */
export const backDoorResponse = (poemLine) => {
  return poemLine.trimEnd().at(-1);
};

/**
 * @param {string} password
 * @returns string
 */
export const backDoorPassword = (password) => {
  const capitalized = frontDoorPassword(password);
  return `${capitalized}, please`;
};
