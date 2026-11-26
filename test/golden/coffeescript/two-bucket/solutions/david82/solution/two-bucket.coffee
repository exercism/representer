class TwoBucket
  constructor: ({bucketOne, bucketTwo, goal, startBucket}) ->
    # Check if goal is impossible
    if goal > Math.max(bucketOne, bucketTwo)
      throw new Error("impossible")
    
    # Check if goal is possible using GCD
    if goal % @gcd(bucketOne, bucketTwo) != 0
      throw new Error("impossible")
    
    @bucketOne = bucketOne
    @bucketTwo = bucketTwo
    @goal = goal
    @startBucket = startBucket

  gcd: (a, b) ->
    while a != b
      if a > b
        a = a - b
      else
        b = b - a
    return a

  measure: ->
    # Setup buckets based on start bucket
    if @startBucket == "one"
      first = new Bucket("one", @bucketOne)
      second = new Bucket("two", @bucketTwo)
    else
      first = new Bucket("two", @bucketTwo)
      second = new Bucket("one", @bucketOne)
    
    # Fill first bucket and start counting
    first.fill()
    moves = 1
    
    # Check for quick match with second bucket
    if @goal == second.size
      second.fill()
      moves++
    
    # Main strategy loop
    while first.amount != @goal and second.amount != @goal
      first.transferTo(second)
      moves++
      
      # Check if goal reached after transfer
      break if first.amount == @goal or second.amount == @goal
      
      # Empty second or fill first
      if second.amount == second.size
        second.empty()
      else
        first.fill()
      moves++
    
    # Prepare result
    if first.amount == @goal
      return {
        moves: moves
        goalBucket: first.name
        otherBucket: second.amount
      }
    else
      return {
        moves: moves
        goalBucket: second.name
        otherBucket: first.amount
      }

class Bucket
  constructor: (@name, @size) ->
    @amount = 0
  
  fill: ->
    @amount = @size
  
  empty: ->
    @amount = 0
  
  transferTo: (target) ->
    space = target.size - target.amount
    if @amount <= space
      target.amount += @amount
      @amount = 0
    else
      @amount -= space
      target.amount += space

module.exports = TwoBucket
