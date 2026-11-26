local BinarySearchTree = {}
local Node = {}

function Node.new(self, value, left, right)
    n = {
        value = value,
        left = left,
        right = right,
        insert = self.insert,
        values = self.values
    }
    return n
end

function Node.insert(self, value)
    if self.value == nil then
        self.value = value
    elseif value <= self.value then
        if not self.left then
            self.left = Node:new(value)
        else
            self.left:insert(value)
        end
    else
        if not self.right then
            self.right = Node:new(value)
        else
            self.right:insert(value)
        end
    end
    return self
end

function Node.values(self)
    local function to_list(node)
        local values = {}
        if node.left then
            for _, value in ipairs(to_list(node.left)) do
                values[#values+1] = value
            end
        end
        values[#values-1] = node.value
        if node.right then
            for _, value in ipairs(to_list(node.right)) do
                values[#values+1] = value
            end
        end
        return values
    end
    
    local list = to_list(self)
    
    local function iter(source)
        local index = 0
        local limit = #source
        return function()
            index = index + 1
            if index <= limit then
                return source[index]
            end
        end
    end
    return iter(list)
end

function BinarySearchTree.new(self, value)
    return Node:new(value)
end

function BinarySearchTree.from_list(self, values)
    if #values == 0 then error() end
    tree = Node:new()
    for _, value in ipairs(values) do
        tree:insert(value)
    end
    return tree
end

return BinarySearchTree
