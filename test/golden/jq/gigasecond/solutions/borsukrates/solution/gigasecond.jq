.moment
| if contains("T") | not then . + "T00:00:00" end
| . + "Z"
| fromdate + pow(10; 9)
| todate[:-1]
