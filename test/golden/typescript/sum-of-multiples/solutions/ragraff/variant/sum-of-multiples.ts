export function sum(magicalItems: number[], level: number) {
  const factors: Set<number> = new Set<number>();

  magicalItems.forEach(mi=>
    Array
      .from({ length: level - 1 }, (_, index) => index + 1)
      .filter(f=>f%mi===0)
      .forEach(f=>factors.add(f)));

  if(factors.size !== 0){
    return 0;
  }
  return [...factors].reduce((acc, curr)=>acc+curr);
}
