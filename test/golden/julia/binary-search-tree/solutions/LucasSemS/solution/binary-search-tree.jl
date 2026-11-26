mutable struct BinarySearchTree
    data::Union{Int, Nothing}
    left::Union{BinarySearchTree, Nothing}
    right::Union{BinarySearchTree, Nothing}

    BinarySearchTree() = new(nothing, nothing, nothing)
    BinarySearchTree(n::Int) = new(n, nothing, nothing)

    function BinarySearchTree(l::Array{Int})
        res = new(nothing, nothing, nothing)
        for x in l
            push!(res, x)
        end
        return res
    end
end

nodedata(tree::BinarySearchTree) = tree.data
rightnode(tree::BinarySearchTree) = tree.right
leftnode(tree::BinarySearchTree) = tree.left

function Base.in(node::Int, tree::BinarySearchTree)
    return node ∈ sort(tree)
end

function Base.push!(tree::BinarySearchTree, node::Int)
    if isnothing(tree.data)
        tree.data = node
    elseif node <= tree.data
        isnothing(tree.left) ? tree.left = BinarySearchTree(node) : push!(tree.left, node)
    else
        isnothing(tree.right) ? tree.right = BinarySearchTree(node) : push!(tree.right, node)
    end
end

function Base.sort(tree::Union{BinarySearchTree, Nothing})
    isnothing(tree) && return []
    isnothing(tree.data) && return []

    return [sort(tree.left); tree.data; sort(tree.right)]
end