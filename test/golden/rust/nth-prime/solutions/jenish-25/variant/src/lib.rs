pub fn nth(n:u32)-> u32{
    let mut count=0;
    let mut i=2;

    while i>0{
        let mut flag=true;
        let mut j=2;
        while j/j <= i{
            if i%j ==0{
                flag=false;
                break;
            }
            j+=1;
        }
        if flag{
            if count == n{
                return i;
            }
            count+=1;
        }
        i+=1;
    }
    0
}