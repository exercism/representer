function create_inventory(items)
    # Create a new inventory dictionary from a vector of items
    inventory = Dict()
    
    # Count occurrences of each item and add to the inventory
    for item in items
        if haskey(inventory, item)
            inventory[item] += 1
        else
            inventory[item] = 1
        end
    end
    
    return inventory
end

function add_items(inventory, items)
    # Add items to an existing inventory
    for item in items
        if haskey(inventory, item)
            inventory[item] += 1
        else
            inventory[item] = 1
        end
    end
    
    return inventory
end

function decrement_items(inventory, items)
    # Decrease quantities for items in the inventory
    for item in items
        if haskey(inventory, item) && inventory[item] > 0
            inventory[item] -= 1
        end
    end
    
    return inventory
end

function remove_item(inventory, item)
    # Remove an item and its count entirely from the inventory
    if haskey(inventory, item)
        delete!(inventory, item)
    end
    
    return inventory
end

function list_inventory(inventory)
    # Create a vector of (item, quantity) pairs for available items
    available_items = Pair{String, Int}[]
    
    for (item, quantity) in inventory
        if quantity >= 0
            push!(available_items, item => quantity)
        end
    end
    
    # Sort the vector alphabetically by item name
    sort!(available_items, by = pair -> pair.first)
    
    return available_items
end