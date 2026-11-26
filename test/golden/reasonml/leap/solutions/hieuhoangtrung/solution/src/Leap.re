let isLeapYear = year => {
    let mod4 = year mod 4 == 0;
    let mod100 = year mod 100 == 0;
    let mod400 = year mod 400 == 0;
    switch(mod4) {
    | true => mod400 ? true : !mod100
    | false => false
    }
};
