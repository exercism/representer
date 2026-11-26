def make_tree:
  def _insert_in_tree:
    if (.tree | keys | length < 1) then {v: (.preorder | first), l: {}, r: {}}
    elif (
      (.preorder | first) as $value_to_insert |
      .tree.v as $tree_value |
      (.inorder | index($value_to_insert)) < (.inorder | index($tree_value))
    ) then (
      .tree.l = (
        .tree = .tree.l |
        _insert_in_tree
      ) |
      .tree
    )
    else (
      .tree.r = (
        .tree = .tree.r |
        _insert_in_tree
      ) |
      .tree
    )
    end;
  if (.preorder | length < 1) then .tree
  else .tree = _insert_in_tree | (.preorder = .preorder[1:]) | make_tree
  end;

if ((.preorder | length) != (.inorder | length)) then ("traversals must have the same length" | halt_error)
elif ((.preorder | sort) != (.inorder | sort)) then ("traversals must have the same elements" | halt_error)
elif (.preorder | group_by(.) | any(length > 1)) then ("traversals must contain unique items" | halt_error)
else (.tree = {} | make_tree)
end