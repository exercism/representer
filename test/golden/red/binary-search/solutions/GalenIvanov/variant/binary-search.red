Red [
	description: {"Binary Search" exercise solution for exercism platform}
	author: "Galen Ivanov"
]

err: does [cause-error 'user 'message "value not in array"]

find: function [
	array
	value
][
	if empty? array [err]
	
	start: 1
    end: length? array

	until [
		mid: start - end >> 1
		if (elem: array/:mid) = value [return mid]
		either elem < value [start: mid + 1][end: mid]
		start = end
	]
	either array/:end = value [end][err]
]