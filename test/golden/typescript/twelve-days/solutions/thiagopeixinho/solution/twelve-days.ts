export function recite(n:number,m:number) :string{
  
  let num:string[]=["first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth"]
  
  let rimes:string[]=
    ["a Partridge in a Pear Tree",
     "two Turtle Doves",
    "three French Hens",
    "four Calling Birds",
    "five Gold Rings",
    "six Geese-a-Laying",
    "seven Swans-a-Swimming",
    "eight Maids-a-Milking",
    "nine Ladies Dancing",
    "ten Lords-a-Leaping",
    "eleven Pipers Piping",
    "twelve Drummers Drumming"]

  function verse(n:number):string { 
    
    if (n==1){return 'On the first day of Christmas my true love gave to me: a Partridge in a Pear Tree.\n'}
    else{
      let a:string=' and a Partridge in a Pear Tree.\n'
      for (let i = 1; i < n; i++) {
        a = " " + rimes[i] + "," + a
      }
      return "On the "+num[n-1]+" day of Christmas my true love gave to me:" + a    
    }
  }
  if(n<0||m<0||n>12||m>12||n>m||n%1!=0||m%1!=0){throw new Error ("Error")}
  else{
    let b:string=""
    for (let i = n; i <= m; i++) {
      b = b + verse(i)
    }
    return b
  }
}
