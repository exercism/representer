USING: ascii kernel sequences ;
IN: pangram

: pangram? ( sentence -- ? )
    >lower '[ _ member? ] "abcdefghijklmnopqrstuvwxyz" swap all? ;