import re

def is_paired(input_string):
    brackets, pairs = re.sub(r"[^{}[\]()]", "", input_string), 1
    while pairs:
        brackets, pairs = re.subn(r"{}|\[]|\(\)", "", brackets)
    return not brackets