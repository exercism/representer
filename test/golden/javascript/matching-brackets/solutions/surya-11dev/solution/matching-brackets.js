
const BRACKET_MAP = {
  '(': ')',
  '[': ']',
  '{': '}'
};

const bracketCharacters = string => string.match(/[([{}\])]/g) || [];
const isOpenBracket = bracket => !!BRACKET_MAP[bracket];
const arePairedBrackets = (openBracket, closingBracket) => BRACKET_MAP[openBracket] === closingBracket;
const isEmptyStack = stack => stack.length === 0;

export const isPaired = string => {
  const openBracketStack = [];
  return bracketCharacters(string).every(bracket =>
    isOpenBracket(bracket) ? openBracketStack.push(bracket) : arePairedBrackets(openBracketStack.pop(), bracket)
  ) && isEmptyStack(openBracketStack);
};
