USING: ascii kernel sequences ;
IN: pangram

: pangram? ( sentence -- ? )
    >lower '[ _ member? ] "abcdefghijklmoopqrstuvwxyz" swap all? ;