export function compute(left: string, right: string): number {
  let counter: number = 0;
  const leftArray: string[] = [...left];
  const rightArray: string[] = [...right];
  if(left.length !== right.length){
    throw new Error('DNA strands must be of equal length.')
  }
  for (let index = 0; index < leftArray.length; index++) {
    if(leftArray[index]!==rightArray[index]){
      counter++;
    }
  }
  return counter;
}
