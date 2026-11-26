def get_coordinate(record):
    return record[1]


def convert_coordinate(coordinate):
    return tuple(list(coordinate))


def compare_records(azara_record, rui_record):
    return convert_coordinate(azara_record[1]) == rui_record[1]


def create_record(azara_record, rui_record):
    return azara_record + rui_record if convert_coordinate(azara_record[1]) == rui_record[1] else 'not a match'


def clean_up(combined_record_group):

    #return ''.join('{}\n'.format(element[:1] + element[2:]) for element in combined_record_group)

    result = ''
    for record in combined_record_group:
        result += f'{record[0], record[2], record[3], record[4]}\n'
    return result
