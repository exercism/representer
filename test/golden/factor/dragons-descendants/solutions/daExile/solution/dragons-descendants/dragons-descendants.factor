USING: kernel math accessors ;
IN: dragons-descendants

TUPLE: dragon name color age ;
C: <dragon> dragon

TUPLE: fire-dragon < dragon flame-temp ;
C: <fire-dragon> fire-dragon

TUPLE: ice-dragon < dragon chill-temp ;
C: <ice-dragon> ice-dragon

TUPLE: volcano-dragon < fire-dragon lava-volume ;
C: <volcano-dragon> volcano-dragon

: age-dragon ( dragon -- ) [ age>> 1 + ] keep age<< ;