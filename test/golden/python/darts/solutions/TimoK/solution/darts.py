from typing import Union

POINTS_FOR_DISTANCE = [(1, 10), (5, 5), (10, 1)]


def score(x: Union[int, float], y: Union[int, float]) -> int:
    distance_to_center = abs(complex(x, y))
    return next((points 
                 for distance, points in POINTS_FOR_DISTANCE 
                 if distance_to_center <= distance)
                , 0)
