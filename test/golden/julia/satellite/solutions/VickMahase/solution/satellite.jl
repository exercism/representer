struct Tree
    root::String
    left::Union{Tree, Nothing}
    right::Union{Tree, Nothing}
end

function tree_from_traversals(preorder, inorder)
    if length(preorder) != length(inorder)
        throw(ArgumentError("Traversals must have the same length"))
    end
    
    if isempty(preorder)
        return nothing
    end
    
    if length(unique(preorder)) != length(preorder)
        throw(ArgumentError("Traversals must contain unique items"))
    end
    
    if Set(preorder) != Set(inorder)
        throw(ArgumentError("Traversals must contain the same items"))
    end

    # Map for O(1) index lookup of elements in the inorder traversal
    inorder_map = Dict{String, Int}()
    for (i, val) in enumerate(inorder)
        inorder_map[val] = i
    end

    function build_tree(pre_start, pre_end, in_start, in_end)
        if pre_start > pre_end
            return nothing
        end

        root_val = preorder[pre_start]
        # We know root_val exists in inorder_map because of the Set check
        root_idx = inorder_map[root_val]

        # Verify structural consistency: the root must be within the current inorder scope
        if !(in_start <= root_idx <= in_end)
             throw(ArgumentError("Inconsistent traversals: root not found in current inorder scope"))
        end

        # The number of nodes in the left subtree is determined by the root's position in inorder
        left_subtree_size = root_idx - in_start
        
        # Recursively build left and right subtrees
        left_child = build_tree(pre_start + 1, pre_start + left_subtree_size, in_start, root_idx - 1)
        right_child = build_tree(pre_start + left_subtree_size + 1, pre_end, root_idx + 1, in_end)

        return Tree(root_val, left_child, right_child)
    end

    return build_tree(1, length(preorder), 1, length(inorder))
end