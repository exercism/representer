# TODO: define the 'EXPECTED_BAKE_TIME' constant
EXPECTED_BAKE_TIME = 40 
# TODO: define the 'PREPARATION_TIME' constant
PREPARATION_TIME = 2

# TODO: define the 'bake_time_remaining()' function
def bake_time_remaining(elapsed_bake_time):
    '''Return remaining baking time.

    This function takes one argument representing elapsed bake time.
'''
    return EXPECTED_BAKE_TIME - elapsed_bake_time

# TODO: define the 'preparation_time_in_minutes()' function
def preparation_time_in_minutes(number_of_layers):
    '''Return preperation time.

    This function takes one argument representing number of layers.
'''
    return number_of_layers * PREPARATION_TIME
    
# TODO: define the 'elapsed_time_in_minutes()' function
def elapsed_time_in_minutes(number_of_layers, elapsed_bake_time):
    '''Return elapsed bake time.

    This function takes two numbers representing the number of layers & the time already spent baking and calculates the total elapsed minutes spent cooking the lasagna.
'''
    return preparation_time_in_minutes(number_of_layers) + elapsed_bake_time