{
    elements = split($0, list, ",")
    start = 1
    stop = elements
    found = -1  
    
    while (start <= stop) 
    {
        mid = int((start + stop) / 2)
        
        if (list[mid] == value) {
            found = mid
            break  
        }
        
        if (value < list[mid]) {
            stop = mid - 1   
        } else {
            start = mid + 1 
        }
    }

    printf("%d\n", found)
}