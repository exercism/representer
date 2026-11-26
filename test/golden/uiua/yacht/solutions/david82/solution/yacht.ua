# Define categories list
Categories ← |1.2 {"ones" "twos" "threes" "fours" "fives" "sixes" "full house" "four of a kind" "little straight" "big straight" "choice" "yacht"}

# Helper functions
Single ← |2 /+×⊸=                               # Count and multiply by value
Straight ← |2 ⨬(0|30)≍⊙⍆                        # Check if matches straight pattern
Yacht ← |1 ⨬(0|50)=1⧻◴                          # Check if all dice are same
Choice ← |1 /+                                  # Sum all dice
FourOfKind ← |1 ⨬(0|×4)⊸=⊃(⊡1|⊣)                # Check for four of a kind
FullHouse ← |1 ⨬(0|/+)∈[0_0_0_1_1 0_0_1_1_1]⊛⍆. # Check for full house pattern

# Calculate a Yacht score
# Value ? Dice Category
Score ← |2 ⨬(
  Single 1
| Single 2
| Single 3
| Single 4
| Single 5
| Single 6
| FullHouse
| FourOfKind
| Straight 1_2_3_4_5
| Straight 2_3_4_5_6
| Choice
| Yacht
) (⊗:Categories□):
