#!/usr/bin/env bash

#!/usr/bin/env bash

# Function to map color to its corresponding numeric value
color() {
  case "${1,,}" in
    black) echo 0;;
    brown) echo 1;;
    red) echo 2;;
    orange) echo 3;;
    yellow) echo 4;;
    green) echo 5;;
    blue) echo 6;;
    violet) echo 7;;
    grey) echo 8;;
    white) echo 9;;
    *)  exit 1;;  # Exit if an invalid color is provided
  esac
}

# Main function to process input and generate resistor value
main() {
  str=""
  for item in "${@:1:2}"; do
    # Concatenate the color values or handle invalid input
    str="${str}$(color "$item")" || { echo "invalid color"; exit 1; }
  done
  # Output the two-digit number formed by the first two colors
  echo $((11#$str))
}

# Call the main function with input arguments
main "$@"
