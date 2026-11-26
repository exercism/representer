Red [
    description: {"Circular Buffer" exercise solution for exercism platform"}
    author: "David82"
]

moveToNextPosition: function [pointer] [
    either empty? next pointer [head pointer] [next pointer]
]

run: function [
    capacity
    operations
] [
    readPointer: writePointer: copy []
    append/dup writePointer false capacity
    parse operations [collect some [
      'write set writeValue skip [
        if (not any [empty? writePointer writePointer/1])
          (writePointer/1: writeValue writePointer: moveToNextPosition writePointer) 
          keep ('true) 
      | keep ('false)
      ]
    | 'read [
        if (readValue: readPointer/1) 
          (readPointer/1: false readPointer: moveToNextPosition readPointer) 
          keep (readValue) 
      | keep ('false)
      ]
    | 'clear (readPointer/1: false)
    | 'overwrite set overwriteValue skip [
        (writePointer/1: overwriteValue readPointer: writePointer: moveToNextPosition writePointer)
      ]
    ]]
]
