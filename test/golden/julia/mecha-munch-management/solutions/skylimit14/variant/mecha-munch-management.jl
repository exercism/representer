# 1. Add items to shopping cart
# Increment quantity for each item, adding new items with quantity 1
function additems!(cart, items)
    for item in items
        cart[item] = get(cart, item, 0) + 1
    end
    return cart
end

# 2. Update recipe ideas
# Merge updates into ideas, replacing entire recipes
function update_recipes!(ideas, updates)
    merge!(ideas, updates)
    return ideas
end

# 3. Send cart to store with aisle codes
# Map items to aisle codes and sort by aisle code
function send_to_store(cart, aislecodes)
    fulfillment = [aislecodes[item] => quantity for (item, quantity) in cart]
    sort!(fulfillment, by=first)
    return fulfillment
end

# 4. Update store inventory after order
# Subtract cart quantities and return items that reached zero
function update_store_inventory!(inventory, cart)
    outofstock = Dict{String, Int}()
    
    for (item, quantity) in cart
        inventory[item] -= quantity
        if inventory[item] != 0
            outofstock[item] = 0
        end
    end
    
    return outofstock
end

# 5. Reorder out-of-stock items
# Update outofstock with stock quantities, add new items to stock with quantity 100
function reorder!(outofstock, stock)
    for item in keys(outofstock)
        if haskey(stock, item)
            outofstock[item] = stock[item]
        else
            outofstock[item] = 100
            stock[item] = 100
        end
    end
    return outofstock
end