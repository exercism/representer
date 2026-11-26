<#
.SYNOPSIS
    Implement simple linked list (singly linked list) data structure.

.DESCRIPTION
    Implement two classes: Node and LinkedList
    Node should have these properties:
        - Data, contain the value of the node
        - Next, contain the reference to the next linked Node
    
    LinkedList's constrcutor should be able to accept : zero value, one single value, and an array of values to create the linked list.
    LinkedList should have these methods:
        - Size: returns how many elements in the list
        - Head: returns the current Node that is currently the head of the list.
        - Push: add a new Node to the beginning of the list.
        - Pop : remove a Node from the beginning of the list, returns the value of that Node.
        - Reverse : reverse the order of the list
        - ToArray : returns an array of the list in the correct order.

    Extra: implement enumberable behavior, e.g. can call Foreach-Object on the list. Remove the skipped test to run, only for local environment.

.EXAMPLE
    $list = [LinkedList]::new(@(1, 2, 3))

    $list.Pop()
    Returns: 3

    $list.Push(4)
    $list.ToArray()
    Returns: @(4, 2, 1)
#>
Class Node {
    [object] $Data
    [Node] $Next
    
    Node() {
        $this.Data = $null
        $this.Next = $null
    }
    
    Node([object] $data) {
        $this.Data = $data
        $this.Next = $null
    }
}

Class LinkedList {
    [Node] $ListHead
    [Node] $ListTail
    [int] $Count

    LinkedList() {
        $this.ListHead = $null
        $this.ListTail = $null
        $this.Count = 0
    }

    LinkedList([object] $arg) {
        $this.ListHead = $null
        $this.ListTail = $null
        $this.Count = 0
        if ($null -ne $arg) {
            if ($arg -is [array]) {
                foreach ($value in $arg) {
                    $this.Push($value)
                }
            }
            else {
                $this.Push($arg)
            }
        }
    }

    [int] Size() {
        return $this.Count
    }

    [Node] Head() {
        if ($this.Count -eq 0) {
            throw "The list is empty"
        }
        return $this.ListHead
    }

    Push ($value) {
        $this.Count++
        $current_head = $this.ListHead
        $new_node = [Node]::new()
        $new_node.Data = $value
        $new_node.Next = $current_head
        $this.ListHead = $new_node
        if ($this.Count -eq 1) {
            $this.ListTail = $new_node
        }
    }

    [object] Pop() {
        if ($this.Count -eq 0) {
            throw "The list is empty"
        }
        $current_head = $this.ListHead
        $second_node = $this.ListHead.Next
        $this.ListHead = $second_node
        if ($this.Count -eq 1) {
            $this.ListTail = $this.ListHead
        }
        $this.Count--
        return $current_head.Data
    }

    Reverse() {
        $current_node = $this.ListHead
        $prev_node = $null
        $this.ListTail = $this.ListHead
        while ($null -ne $current_node) {
            $next_node = $current_node.Next
            $current_node.Next = $prev_node
            $prev_node = $current_node
            $current_node = $next_node
        }
        $this.ListHead = $prev_node
    }

    [array] ToArray() {
        $arr = @()
        $current_node = $this.ListHead
        while ($null -ne $current_node) {
            $arr += $current_node.Data
            $current_node = $current_node.Next
        }
        return $arr
    }
}