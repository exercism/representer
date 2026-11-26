(defmodule binary-search-tree
  (export (from-list 2)
          (sorted-data 1)))

;;; Insert a value into the BST
;;; Empty tree case: creates a new tree-node
(defun insert
  ((val 'empty-tree)
   (tuple 'tree-node val 'empty-tree 'empty-tree))
  ;; Values less than or equal to current node go to the left subtree
  ((val (tuple 'tree-node data left right)) (when (=< val data))
   (tuple 'tree-node data (insert val left) right))
  ;; Values strictly greater than current node go to the right subtree
  ((val (tuple 'tree-node data left right))
   (tuple 'tree-node data left (insert val right))))

;;; Construct a binary search tree from a list of elements
(defun from-list (list)
  (lists:foldl (lambda (val tree) (insert val tree)) 'empty-tree list))

;;; Perform an in-order traversal to retrieve sorted data
(defun sorted-data
  (('empty-tree)
   '())
  (((tuple 'tree-node data left right))
   (++ (sorted-data left)
       (list data)
       (sorted-data right))))