update "protein-translation"
set (result, error) = (
    with
    map(code, name) as (
        values
        ('AUG', 'Methionine'),
        ('UUU', 'Phenylalanine'),
        ('UUC', 'Phenylalanine'),
        ('UUA', 'Leucine'),
        ('UUG', 'Leucine'),
        ('UCU', 'Serine'),
        ('UCC', 'Serine'),
        ('UCA', 'Serine'),
        ('UCG', 'Serine'),
        ('UAU', 'Tyrosine'),
        ('UAC', 'Tyrosine'),
        ('UGU', 'Cysteine'),
        ('UGC', 'Cysteine'),
        ('UGG', 'Tryptophan'),
        ('UAA', 'STOP'),
        ('UAG', 'STOP'),
        ('UGA', 'STOP')
    ),
    trans as (
        select 1 as i, '' as out
        union all
        select i + 3, out || ', ' || ifnull((select name from map where code = substr(strand, i, 3)), 'ERR')
        from trans
        where substr(strand, i, 3) != ''
        and ifnull((select name from map where code = substr(strand, i, 3)), '') != 'STOP'
    )
    select iif(out like '%ERR', null, ltrim(out, ', ')), iif(out like '%ERR', 'Invalid codon', null)
    from trans
    where i = (select max(i) from trans)
)

