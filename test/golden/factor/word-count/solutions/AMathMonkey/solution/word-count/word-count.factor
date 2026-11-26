USING: kernel regexp math.statistics unicode ;
IN: word-count

: count-words ( sentence -- counts )
    >lower R/ ((\w'?)*\w)+/ all-matching-subseqs histogram ;
