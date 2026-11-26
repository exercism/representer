def totree:
	if has(0)
	then
		.[0] as $first |
		reduce .[1:][] as $o (
			{v: $first.v, l: [], r: []};
			if $o.position < $first.position
			then .l
			else .r
			end += [$o]
		) | (.l, .r) |= totree
	else {}
	end
;

if [.preorder, .inorder | length] | .[0] != .[1]
then "traversals must have the same length" | halt_error
elif [.preorder, .inorder | sort] | .[0] != .[1]
then "traversals must have the same elements" | halt_error
elif any(.preorder | group_by(.)[]; length > 1)
then "traversals must contain unique items" | halt_error
else
	.inorder as $inorder |
	.preorder |
	map({v: ., position: $inorder[[.]][0]}) |
	totree
end
