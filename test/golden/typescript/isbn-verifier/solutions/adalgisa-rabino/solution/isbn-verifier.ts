export function isValid(isbn: string): any {
  function reducer(pv: number, cv: number, index: number) {
  pv += Number(cv) * (10-index);
  return pv
}
   let s: string = isbn.replace(/-/g, "")
   let res: number
    if(s.length == 10 && (/\d{9,10}[X]?$/g).test(s)){
        res = s.split("").map(n => (n.match(/\d/))? Number(n) : 10).reduce(reducer, 0);
        return (res%11 == 0)? true : false
    }
}