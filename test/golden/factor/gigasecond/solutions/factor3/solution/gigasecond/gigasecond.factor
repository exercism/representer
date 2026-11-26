USING: calendar calendar.format calendar.parser kernel
sequences splitting ;
IN: gigasecond

: gigasecond-after ( moment -- moment )
    dup length 10 =
    [ ymd>timestamp ] [ rfc3339>timestamp ] if
    1,000,000,000 seconds time+
    timestamp>rfc3339 "." split1 drop ;