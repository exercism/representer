function allocateCubicles(int[] requests) returns int[] {
    int[] distinctArr = [];
    foreach var e in requests{
        if (distinctArr.indexOf(e) is ()){
            distinctArr.push(e);
        }
    }
    int[] allocations = distinctArr.sort();
    return allocations;
}