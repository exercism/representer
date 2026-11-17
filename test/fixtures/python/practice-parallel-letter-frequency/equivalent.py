from collections import Counter
from threading import Lock, Thread
from time import sleep
from queue import Queue
placeholder_0 = 3

class placeholder_1:

    def __init__(self):
        self.placeholder_3 = Lock()
        self.placeholder_4 = Counter()

    def placeholder_5(self, placeholder_6):
        self.placeholder_3.acquire()
        try:
            self.placeholder_4 = self.placeholder_4 + placeholder_6
        finally:
            self.placeholder_3.release()

def placeholder_7(placeholder_8, placeholder_9, placeholder_10):
    while not placeholder_8.empty():
        sleep(placeholder_10 + 1)
        placeholder_11 = placeholder_8.get()
        if placeholder_11 is not None:
            placeholder_12 = Counter((placeholder_13 for placeholder_13 in placeholder_11.lower() if placeholder_13.isalpha()))
            placeholder_9.placeholder_5(placeholder_12)
        placeholder_8.task_done()
        if placeholder_11 is None:
            break

def placeholder_14(placeholder_15):
    placeholder_8 = Queue()
    for placeholder_16 in placeholder_15:
        placeholder_8.put(placeholder_16)
    placeholder_9 = placeholder_1()
    placeholder_17 = []
    for placeholder_13 in range(placeholder_0):
        placeholder_18 = Thread(target=placeholder_7, args=(placeholder_8, placeholder_9, placeholder_13))
        placeholder_18.start()
        placeholder_17.append(placeholder_18)
    placeholder_8.join()
    for _ in range(placeholder_0):
        placeholder_8.put(None)
    for placeholder_22 in placeholder_17:
        placeholder_22.join()
    return placeholder_9.placeholder_4
