let isLeapYear = year => 
    switch( year mod 4, year mod 100, year mod 400) {
    |   (_,_,0) => true
    |   (_,0,_) => false
    |   (0,_,_) => true
    |   _ => false
    };


