# EXPECTED_BAKE_TIME
EXPECTED_BAKE_TIME = 40
# TODO: consider defining the 'PREPARATION_TIME' constant equal to the time it takes to prepare a single layer
PREPARATION_TIME = 2

def bake_time_remaining(elapsed_bake_time):
    """Calculate the bake time remaining.
    
    :param elapsed_bake_time: int - baking time already elapsed.
    :return: int - remaining bake time (in minutes) derived from 'EXPECTED_BAKE_TIME'.
    Function that takes the actual minutes the lasagna has been in the oven as
    an argument and returns how many minutes the lasagna still needs to bake
    based on the `EXPECTED_BAKE_TIME`.
    """
  
    # TODO: define the 'bake_time_remaining()' function
    bake_time_remaining = EXPECTED_BAKE_TIME - elapsed_bake_time
    return bake_time_remaining
print(bake_time_remaining.__doc__)
          
def preparation_time_in_minutes(number_of_lay):
    """Calculate the bake time remaining.
    
    :param elapsed_bake_time: int - baking time already elapsed.
    :return: int - remaining bake time (in minutes) derived from 'EXPECTED_BAKE_TIME'.
    Function that takes the actual minutes the lasagna has been in the oven as
    an argument and returns how many minutes the lasagna still needs to bake
    based on the `EXPECTED_BAKE_TIME`.
    """
    # TODO: define the 'preparation_time_in_minutes()' function and consider using 'PREPARATION_TIME' here
    a = number_of_lay * PREPARATION_TIME 
    return a
print(preparation_time_in_minutes.__doc__)

def elapsed_time_in_minutes(number_of_layers, elapsed_bake_time):
    """Calculate the bake time remaining.
    
    :param elapsed_bake_time: int - baking time already elapsed.
    :return: int - remaining bake time (in minutes) derived from 'EXPECTED_BAKE_TIME'.
    Function that takes the actual minutes the lasagna has been in the oven as
    an argument and returns how many minutes the lasagna still needs to bake
    based on the `EXPECTED_BAKE_TIME`.
    """
  
    #Return elapsed cooking time.
    #This function takes two numbers representing the number of layers & the time already spent baking and calculates the total elapsed minutes spent cooking the lasagna.
        
    PREPARATION_TIME = 2
    elapsed_cooking_time = number_of_layers * PREPARATION_TIME + elapsed_bake_time
    return elapsed_cooking_time
print(elapsed_time_in_minutes.__doc__)
  

    
