module InterestIsInteresting

let interestRate (balance: decimal): single =
   //failwith "Please implement the 'interestRate' function"
   match balance with
   | b when b < 0m -> 3.213f
   | b when b >= 5000m -> 2.475f
   | b when b >= 1000m -> 1.621f
   | b when b >= 0m -> 0.5f
   | _ -> 0.0f

let interest (balance: decimal): decimal =
   decimal (interestRate balance) * balance / 100m
   //failwith "Please implement the 'interest' function"

let annualBalanceUpdate(balance: decimal): decimal =
   //failwith "Please implement the 'annualBalanceUpdate' function"
   balance + interest balance

let amountToDonate(balance: decimal) (taxFreePercentage: float): int =
   //failwith "Please implement the 'amountToDonate' function"
   match balance with
   | b when b > 0m -> int (balance * decimal(taxFreePercentage) / 100.0m * 2.0m)
   | b when b <= 0m -> 0
   | _ -> 0
