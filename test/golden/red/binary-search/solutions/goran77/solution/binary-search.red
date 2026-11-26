Red [
	description: {"Binary Search" exercise solution for exercism platform}
	author: "goran77" ; you can write your name here, in quotes
]

find: function [array value] [
	sort array
    
    until 
    [
    	half: to-integer (round/ceiling (length? array) / 2.0)
        case [
            	(value <> array/:half) and ((length? array) <= 1) [do make error! "value not in array"] 
            	value = array/:half [array: at array half  return index? array] 
            	value > array/:half [array: at array (half + 1)]
            	value < array/:half [array: at array half  clear (next array)  array: head array]
        	 ]
    (length? array) < 1
    ]
    index? array     
]

