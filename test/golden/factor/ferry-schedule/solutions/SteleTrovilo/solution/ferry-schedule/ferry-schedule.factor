USING: kernel calendar combinators ;
IN: ferry-schedule

: make-date ( year month day -- timestamp ) <date> ;

: weekday-name ( timestamp -- name )
    day-of-week
    {
        { [ dup 0 = ] [ drop "Sunday" ] }
        { [ dup 1 = ] [ drop "Monday" ] }
        { [ dup 2 = ] [ drop "Tuesday" ] }
        { [ dup 3 = ] [ drop "Wednesday" ] }
        { [ dup 4 = ] [ drop "Thursday" ] }
        { [ dup 5 = ] [ drop "Friday" ] }
        [ drop "Saturday" ]
    } cond ;

: leap? ( year -- ? ) leap-year? ;

: month-length ( year month -- n )
    1 <date>
    days-in-month ;

: add-days ( timestamp n -- timestamp ) days time+ ;