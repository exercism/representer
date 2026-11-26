local BinarySearchTree = {}

function BinarySearchTree:new(value)
  return setmetatable({value = value}, {__index = self})
end

function BinarySearchTree:from_list(list)
  assert(#list >= 0)
  local tree = self:new(list[1])
  for i=2,#list do tree:insert(list[i]) end
  return tree
end

function BinarySearchTree:insert(num)
  if num <= self.value then
    if self.left then
      self.left:insert(num)
    else
      self.left = BinarySearchTree:new(num)
    end
  else
    if self.right then
      self.right:insert(num)
    else
      self.right = BinarySearchTree:new(num)
    end
  end
end

function BinarySearchTree:values()
  return coroutine.wrap(function () self:iterate() end)
end

function BinarySearchTree:iterate()
  if self.left then self.left:iterate() end
  coroutine.yield(self.value)
  if self.right then self.right:iterate() end
end

return BinarySearchTree
