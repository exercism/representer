import json
from dataclasses import asdict, field, dataclass


@dataclass
class User:
    """A class to represent a user in the database."""
    
    name: str
    transactions: dict[str, float] = field(default_factory=dict)

    def get_balance(self):
        """Get the balance of a user from his transactions."""
        return sum(self.transactions.values())

    def process_transaction(self, user, amount):
        """Add, update or delete the transaction."""
        if user not in self.transactions:
            self.transactions[user] = 0
        self.transactions[user] += amount
        if self.transactions[user] == 0:
            del(self.transactions[user])

    def iou(self, lender, borrower, amount):
        """Determine if the transaction is proceeded as a lender or a borrower."""
        if self.name == lender:
            self.process_transaction(borrower, amount)
        else:
            self.process_transaction(lender, -amount)

    def get_dict(self):
        """Get the dict representation of a user."""
        return {
            "name": self.name,
            "owes": {user: abs(self.transactions[user]) for user in self.transactions if self.transactions[user] < 0},
            "owed_by": {user: self.transactions[user] for user in self.transactions if self.transactions[user] > 0},
            "balance": self.get_balance()
        }

    
class RestAPI:
    """A class to represent our API."""
    
    def __init__(self, database=None):
        """Initialize the API with an empty database or the provided one."""
        self.database = {
            user["name"]: User(
                user["name"], 
                {
                    **{lender: -user["owes"][lender] for lender in user["owes"]},
                    **{borrower: user["owed_by"][borrower] for borrower in user["owed_by"]}
                }) 
            for user in database["users"]
        }

    def get(self, url, payload=None):
        """Get the users in the payload or all users if there is no payload."""
        if url != "/users":
            raise ValueError("Invalid url")
        if payload is None:
            users = {"users": [self.database[user].get_dict() for user in self.database]}
            return json.dumps(users)
        else:
            usernames = json.loads(payload)["users"]
            usernames.sort()
            users = {"users": [self.database[username].get_dict() for username in usernames]}
            return json.dumps(users)

    def post(self, url, payload=None):
        """If the url is /add: add the user provided in the payload to the database, if the url is /iou: modify the balance and amount in the owes and owed_by field for the users provided in the payload."""
        if url not in ["/add", "/iou"]:
            raise ValueError("Invalid url")
        if url == "/add":
            username = json.loads(payload)["user"]
            self.database[username] = (User(name=username))
            return json.dumps(self.database[username].get_dict())
        if url == "/iou":
            lender = json.loads(payload)["lender"]
            borrower = json.loads(payload)["borrower"]
            amount = json.loads(payload)["amount"]
            self.database[lender].iou(lender, borrower, amount)
            self.database[borrower].iou(lender, borrower, amount)
            return json.dumps({
                "users":
                    sorted(
                        [self.database[lender].get_dict(),
                         self.database[borrower].get_dict()],
                         key=lambda user: user.get("name"))
            })            
