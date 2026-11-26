import random

def private_key(p):
    return random.randint(2,p-1)


def public_key(p, g, private):
    """
    A = g**a mod p
    :return:
    """
    return (g**private) % p


def secret(p, public, private):
    """
    s = B**a mod p
    """
    return (public**private) % p 
