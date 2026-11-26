package binary_search_tree

Tree :: ^Node

Node :: struct {
	value: int,
	left:  Tree,
	right: Tree,
}

destroy_tree :: proc(t: Tree) {
	if t == nil do return
    if t.left != nil do destroy_tree(t.left)
    if t.right != nil do destroy_tree(t.right)
    free(t)    
}

insert :: proc(t: ^Tree, value: int) {
    if t^ == nil {
        t^ = new(Node)
        t^.value = value
        return
    }
    if value <= t^.value do insert(&(t^.left), value)
    else do                 insert(&(t^.right), value)
}

sorted_data :: proc(t: Tree) -> []int {
    result := make([dynamic]int)
    sorted_data_loop(t, &result)
	return result[:]
}

sorted_data_loop :: proc(t: Tree, s: ^[dynamic]int) {
	stack := make([dynamic]Tree)
	defer delete(stack) 

	curr := t
	for curr != nil || len(stack) > 0 {
		for curr != nil {
			append(&stack, curr)
			curr = curr.left
		}
		
		curr = pop(&stack)
		append(s, curr.value)
		
		curr = curr.right
	}
}