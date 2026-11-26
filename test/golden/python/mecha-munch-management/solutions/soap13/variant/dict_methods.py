"""Functions to manage a users shopping cart items."""


def add_item(current_cart, items_to_add):
    """Add items to shopping cart.

    :param current_cart: dict - the current shopping cart.
    :param items_to_add: iterable - items to add to the cart.
    :return: dict - the updated user cart dictionary.
    """

    cart = current_cart
    for item  in items_to_add:
        if item not in cart:
            cart[item] = 1
        else:
            cart[item] += 1
    return cart


def read_notes(notes):
    """Create user cart from an iterable notes entry.

    :param notes: iterable of items to add to cart.
    :return: dict - a user shopping cart dictionary.
    """

    return {a:1 for a in notes}


def update_recipes(ideas, recipe_updates):
    """Update the recipe ideas dictionary.

    :param ideas: dict - The "recipe ideas" dict.
    :param recipe_updates: iterable -  with updates for the ideas section.
    :return: dict - updated "recipe ideas" dict.
    """

    ideas.update(recipe_updates)
    return ideas
            


def sort_entries(cart):
    """Sort a users shopping cart in alphabetically order.

    :param cart: dict - a users shopping cart dictionary.
    :return: dict - users shopping cart sorted in alphabetical order.
    """

    abc = dict(sorted(cart.items()))
    return abc
    


def send_to_store(cart, aisle_mapping):
    """Combine users order to aisle and refrigeration information.

    :param cart: dict - users shopping cart dictionary.
    :param aisle_mapping: dict - aisle and refrigeration information dictionary.
    :return: dict - fulfillment dictionary ready to send to store.
    """

    done = {}
    for item in cart:
        done[item] = [cart[item]] + aisle_mapping[item] 
    doned = dict(reversed(sorted(done.items())))
    return doned


def update_store_inventory(fulfillment_cart, store_inventory):
    """Update store inventory levels with user order.

    :param fulfillment cart: dict - fulfillment cart to send to store.
    :param store_inventory: dict - store available inventory
    :return: dict - store_inventory updated.
    """

    store = {}
    for item, key in fulfillment_cart.items():
        needed = key[0]
        have = store_inventory[item][0]
        new = have + needed
        if new == 0:
            new = "Out of Stock"
        store[item] = [new , fulfillment_cart[item][1] , fulfillment_cart[item][2]]
    why =  store_inventory.update(store)
    return store_inventory
