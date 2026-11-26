"""Functions to keep track and alter inventory."""


def create_inventory(items_inventory):
    """Create a dict that tracks the amount (count) of each element on the `items` list.

    :param items: list - list of items to create an inventory from.
    :return: dict - the inventory dictionary.
    """
    result = {}

    for index, item in enumerate(items_inventory):
        if item not in result:
            result[item] = 1
        else:
            result[item] += 1
    return result



def add_items(inventory, items):
    """Add or increment items in inventory using elements from the items `list`.

    :param inventory: dict - dictionary of existing inventory.
    :param items: list - list of items to update the inventory with.
    :return: dict - the inventory updated with the new items.
    """

    new_items = create_inventory(items)
    print(new_items)

    if inventory == {}:
        return new_items

    for item in new_items:
        if item not in inventory:
            print(f"added new item {item} to inventory")
            inventory[item] = new_items[item]
        elif item in inventory:
            print(f"incremented item {item} by {new_items[item]} to inventory")
            inventory[item] += new_items[item]
    return inventory


def decrement_items(inventory, items):
    """Decrement items in inventory using elements from the `items` list.

    :param inventory: dict - inventory dictionary.
    :param items: list - list of items to decrement from the inventory.
    :return: dict - updated inventory with items decremented.
    """

    new_items = create_inventory(items)
    print(new_items)

    if inventory == {}:
        return new_items

    for item in new_items:
        if item in inventory:
            inventory[item] -= new_items[item]
        if inventory[item] < 0:
            inventory[item] = 0
    
    return inventory


def remove_item(inventory, item):
    """Remove item from inventory if it matches `item` string.

    :param inventory: dict - inventory dictionary.
    :param item: str - item to remove from the inventory.
    :return: dict - updated inventory with item removed. Current inventory if item does not match.
    """

    for object in list(inventory):
        if object == item:
            inventory.pop(item)
    return inventory


def list_inventory(inventory):
    """Create a list containing all (item_name, item_count) pairs in inventory.

    :param inventory: dict - an inventory dictionary.
    :return: list of tuples - list of key, value pairs from the inventory dictionary.
    """

    result = []
    pair = ()

    for item in inventory:
        if inventory[item] > 0:
            pair = (item, inventory[item])
            result.append(pair)
    return result
