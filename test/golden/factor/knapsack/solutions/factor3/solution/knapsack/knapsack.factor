USING: accessors kernel math math.combinatorics sequences ;
IN: knapsack

TUPLE: item weight value ;

: maximum-value ( max-weight items -- value )
    all-subsets [ [ weight>> ] map-sum >= ] with filter
    [ [ value>> ] map-sum ] map maximum ;