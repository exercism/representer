import json

class placeholder_0:

    def __init__(self, placeholder_2=None):
        self.placeholder_2 = placeholder_2 or {'users': []}

    def update(self):
        for placeholder_4 in self.placeholder_2['users']:
            placeholder_5 = placeholder_4['owed_by']
            placeholder_6 = placeholder_4['owes']
            for placeholder_7 in list(placeholder_5.keys()):
                if placeholder_7 in placeholder_6:
                    placeholder_8 = 0
                    if placeholder_7 in placeholder_6:
                        placeholder_8 = placeholder_6[placeholder_7]
                        del placeholder_6[placeholder_7]
                    if placeholder_7 in placeholder_5:
                        placeholder_8 -= placeholder_5[placeholder_7]
                        del placeholder_5[placeholder_7]
                    if placeholder_8 > 0:
                        placeholder_6[placeholder_7] = placeholder_8
                    elif placeholder_8 < 0:
                        placeholder_5[placeholder_7] = -placeholder_8
            placeholder_4['balance'] = sum(placeholder_5.values()) - sum(placeholder_6.values())

    def get(self, placeholder_10, placeholder_11=None):
        if placeholder_11 is not None:
            placeholder_11 = json.loads(placeholder_11)
        if placeholder_10 == '/users':
            if placeholder_11 is None:
                return json.dumps(self.placeholder_2)
            else:
                return json.dumps({'users': [placeholder_4 for placeholder_4 in self.placeholder_2['users'] if placeholder_4['name'] in placeholder_11['users']]})
        return None

    def placeholder_12(self, placeholder_10, placeholder_11=None):
        placeholder_13 = None
        if placeholder_11 is not None:
            placeholder_11 = json.loads(placeholder_11)
        if placeholder_10 == '/add':
            if placeholder_11 is not None:
                placeholder_14 = placeholder_11['user']
                placeholder_15 = self.placeholder_2['users']
                placeholder_4 = None
                for placeholder_16 in placeholder_15:
                    if placeholder_16['name'] == placeholder_14:
                        placeholder_4 = placeholder_16
                        break
                if placeholder_4 is None:
                    placeholder_17 = {'name': placeholder_14, 'owes': {}, 'owed_by': {}, 'balance': 0}
                    placeholder_15.append(placeholder_17)
                    self.update()
                    placeholder_13 = json.dumps(placeholder_17)
        elif placeholder_10 == '/iou':
            if placeholder_11 is not None:
                placeholder_18 = placeholder_11['lender']
                placeholder_19 = placeholder_11['borrower']
                placeholder_20 = placeholder_11['amount']
                placeholder_21 = placeholder_22 = None
                for placeholder_4 in self.placeholder_2['users']:
                    if placeholder_4['name'] == placeholder_18:
                        placeholder_21 = placeholder_4
                    elif placeholder_4['name'] == placeholder_19:
                        placeholder_22 = placeholder_4
                if placeholder_21 is not None and placeholder_22 is not None:
                    placeholder_21['owed_by'].setdefault(placeholder_19, 0)
                    placeholder_21['owed_by'][placeholder_19] += placeholder_20
                    placeholder_22['owes'].setdefault(placeholder_18, 0)
                    placeholder_22['owes'][placeholder_18] += placeholder_20
                    self.update()
                    placeholder_13 = self.get('/users', json.dumps({'users': [placeholder_18, placeholder_19]}))
        return placeholder_13
