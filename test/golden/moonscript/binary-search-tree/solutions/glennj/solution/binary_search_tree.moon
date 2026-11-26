class BinarySearchTree
  new: (items = {}) =>
    @value = nil
    @add item for item in *items

  add: (item) =>
    if @value == nil
      @value = item
    elseif item <= @value
      @left = @left or BinarySearchTree!
      @left\add item
    else
      @right = @right or BinarySearchTree!
      @right\add item

  data: =>
    {
      left: @left and @left\data! or nil
      data: @value
      right: @right and @right\data! or nil
    }

  sorted: =>
    doSort = (tree, values) ->
      values = doSort tree.left, values if tree.left
      table.insert values, tree.value
      values = doSort tree.right, values if tree.right
      values
      
    doSort @, {}
