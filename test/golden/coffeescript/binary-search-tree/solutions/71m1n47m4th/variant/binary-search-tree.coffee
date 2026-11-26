module.exports = class BST
  constructor: (@data) ->
  insert: (data) ->
    if data < @data
      if @left?
        @left.insert data
      else
        @left = new BST data
    else
      if @right?
        @right.insert data
      else
        @right = new BST data

  each: (callback) ->
    @left.each callback if @left?
    callback @data
    @right.each callback if @right?
