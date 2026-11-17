""" Classes:
    Some weird and corner cases we suspect might choke the
    representer.

    These include:
    - nested classes
    - classes with pass
    - classes with ...
    - classes with unassigned but type-hinted class vars
    -other craziness as we come across it.
"""
from collections import deque

class placeholder_0(BufferError):
    """
    Docstring with only an ellipsis body.
    """
    ...

class placeholder_1(BufferError):
    """
    Docstring with only a pass body.
    """
    pass

class placeholder_1(BufferError):
    """
    Docstring with a pass method.
    """

    def placeholder_2(self):
        pass

class placeholder_1(BufferError):
    """
    Docstring with a ellipsis method.
    """

    def placeholder_2(self):
        ...

class placeholder_3:
    """
    Unassigned but typehinted class vars.
    """
    placeholder_4: int
    placeholder_5: str

    def __init__(self, placeholder_7: int):
        self.placeholder_8 = deque([], placeholder_7)

    def read(self):
        if not self.placeholder_8:
            raise placeholder_1('Circular buffer is empty')
        return self.placeholder_8.popleft()

    def write(self, placeholder_11):
        if len(self.placeholder_8) == self.placeholder_8.maxlen:
            raise placeholder_0('Circular buffer is full')
        self.placeholder_8.append(placeholder_11)

    def placeholder_12(self, placeholder_11):
        if len(self.placeholder_8) == self.placeholder_8.maxlen:
            self.read()
        self.write(placeholder_11)

    def clear(self):
        self.placeholder_8.clear()

class placeholder_14:
    """
        A class with an inner class and methods.
    """
    placeholder_15: int

    def __init__(self):
        self.placeholder_16 = self.placeholder_18()
        self.placeholder_17: str

    class placeholder_18:
        placeholder_19: int

        def __init__(self):
            self.placeholder_20 = 100000

        def placeholder_21(self, placeholder_22):
            self.placeholder_20 -= placeholder_22

        def placeholder_23(self, placeholder_22):
            self.placeholder_20 += placeholder_22

        def placeholder_24(self):
            ...
