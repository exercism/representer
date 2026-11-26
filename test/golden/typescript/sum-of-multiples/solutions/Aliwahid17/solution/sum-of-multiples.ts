export function sum(multiples:number[], limits:number) {
   let value = [];
  for (let i = 0; i < limits; i++) 
  {
    for (let index of multiples)
    {
      let multi = i * index;
      if(multi < limits)
      {
        value.push(multi);
      }
    }
  }
  let newValue = [...new Set(value)]
  let sum = 0;
newValue.forEach(num => {
  sum += num;
});
return sum;
  
  
}
