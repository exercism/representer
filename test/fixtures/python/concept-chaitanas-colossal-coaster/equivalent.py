"""Functions to manage and organize queues at Chaitana's roller coaster."""

def placeholder_0(placeholder_1, placeholder_2, placeholder_3, placeholder_4):
    """Add a person to the 'express' or 'normal' queue depending on the ticket number.

    :param express_queue: list - names in the Fast-track queue.
    :param normal_queue: list - names in the normal queue.
    :param ticket_type: int - type of ticket. 1 = express, 0 = normal.
    :param person_name: str - name of person to add to a queue.
    :return: list - the (updated) queue the name was added to.
    """
    placeholder_5 = placeholder_1 if placeholder_3 == 1 else placeholder_2
    placeholder_5.append(placeholder_4)
    return placeholder_5

def placeholder_6(placeholder_7, placeholder_8):
    """Search the queue for a name and return their queue position (index).

    :param queue: list - names in the queue.
    :param friend_name: str - name of friend to find.
    :return: int - index at which the friends name was found.
    """
    return placeholder_7.index(placeholder_8)

def placeholder_9(placeholder_7, placeholder_10, placeholder_4):
    """Insert the late arrival's name at a specific index of the queue.

    :param queue: list - names in the queue.
    :param index: int - the index at which to add the new name.
    :param person_name: str - the name to add.
    :return: list - queue updated with new name.
    """
    placeholder_7.insert(placeholder_10, placeholder_4)
    return placeholder_7

def placeholder_11(placeholder_7, placeholder_4):
    """Remove the mean person from the queue by the provided name.

    :param queue: list - names in the queue.
    :param person_name: str - name of mean person.
    :return: list - queue update with the mean persons name removed.
    """
    placeholder_7.remove(placeholder_4)
    return placeholder_7

def placeholder_12(placeholder_7, placeholder_4):
    """Count how many times the provided name appears in the queue.

    :param queue: list - names in the queue.
    :param person_name: str - name you wish to count or track.
    :return: int - the number of times the name appears in the queue.
    """
    return placeholder_7.count(placeholder_4)

def placeholder_13(placeholder_7):
    """Remove the person in the last index from the queue and return their name.

    :param queue: list - names in the queue.
    :return: str - name that has been removed from the end of the queue.
    """
    return placeholder_7.pop()

def placeholder_14(placeholder_7):
    """Sort the names in the queue in alphabetical order and return the result.

    :param queue: list - names in the queue.
    :return: list - copy of the queue in alphabetical order.
    """
    placeholder_15 = placeholder_7[:]
    placeholder_15.sort()
    return placeholder_15
