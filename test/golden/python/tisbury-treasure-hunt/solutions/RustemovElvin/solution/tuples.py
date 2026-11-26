def get_coordinate(record):
    return record[1]


def convert_coordinate(coordinate):
    return tuple(coordinate)


def compare_records(azara_record, rui_record):
    if tuple(azara_record[1]) == tuple(rui_record[1]):
        return True
    return False

def create_record(azara_record, rui_record):
    if tuple(azara_record[1]) == tuple(rui_record[1]):
        return azara_record + rui_record
    else:
        return 'not a match'


def clean_up(combined_record_group):
    return ''.join('{}\n'.format(element[:1] + element[2:]) for element in             combined_record_group)