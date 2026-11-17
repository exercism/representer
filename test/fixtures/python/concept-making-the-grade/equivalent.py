"""Functions for organizing and calculating student exam scores."""

def placeholder_0(placeholder_1):
    """Round all provided student scores.

    :param student_scores: list - float or int of student exam scores.
    :return: list - student scores *rounded* to nearest integer value.
    """
    placeholder_2 = []
    while placeholder_1:
        placeholder_2.append(round(placeholder_1.pop()))
    return placeholder_2

def placeholder_3(placeholder_1):
    """Count the number of failing students out of the group provided.

    :param student_scores: list - containing int student scores.
    :return: int - count of student scores at or below 40.
    """
    placeholder_4 = 0
    for placeholder_5 in placeholder_1:
        if placeholder_5 <= 40:
            placeholder_4 += 1
    return placeholder_4

def placeholder_6(placeholder_1, placeholder_7):
    """Determine how many of the provided student scores were 'the best' based on the provided threshold.

    :param student_scores: list - of integer scores.
    :param threshold: int - threshold to cross to be the "best" score.
    :return: list - of integer scores that are at or above the "best" threshold.
    """
    placeholder_8 = []
    for placeholder_5 in placeholder_1:
        if placeholder_5 >= placeholder_7:
            placeholder_8.append(placeholder_5)
    return placeholder_8

def placeholder_9(placeholder_10):
    """Create a list of grade thresholds based on the provided highest grade.

    :param highest: int - value of highest exam score.
    :return: list - of lower threshold scores for each D-A letter grade interval.
            For example, where the highest score is 100, and failing is <= 40,
            The result would be [41, 56, 71, 86]:

            41 <= "D" <= 55
            56 <= "C" <= 70
            71 <= "B" <= 85
            86 <= "A" <= 100
    """
    placeholder_11 = round((placeholder_10 - 40) / 4)
    placeholder_12 = []
    for placeholder_5 in range(41, placeholder_10, placeholder_11):
        placeholder_12.append(placeholder_5)
    return placeholder_12

def placeholder_13(placeholder_1, placeholder_14):
    """Organize the student's rank, name, and grade information in ascending order.

    :param student_scores: list - of scores in descending order.
    :param student_names: list - of string names by exam score in descending order.
    :return: list - of strings in format ["<rank>. <student name>: <score>"].
    """
    placeholder_15 = []
    for placeholder_16, placeholder_17 in enumerate(placeholder_14):
        placeholder_18 = str(placeholder_16 + 1) + '. ' + placeholder_17 + ': ' + str(placeholder_1[placeholder_16])
        placeholder_15.append(placeholder_18)
    return placeholder_15

def placeholder_19(placeholder_20):
    """Create a list that contains the name and grade of the first student to make a perfect score on the exam.

    :param student_info: list - of [<student name>, <score>] lists.
    :return: list - first `[<student name>, 100]` or `[]` if no student score of 100 is found.
    """
    placeholder_21 = []
    for placeholder_22 in placeholder_20:
        if placeholder_22[1] == 100:
            placeholder_21 = placeholder_22
            break
    return placeholder_21
