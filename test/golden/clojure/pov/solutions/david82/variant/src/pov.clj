(ns pov)

(defn- find-path-to-target
  "Finds a path to the target node within a tree"
  [target-node [current-label & current-subtrees :as current-tree]]
  (when (seq current-tree) ; Ensure current tree is not empty
    (if (= target-node current-label)
      [current-label] ; Target found, return current path
      (some #(let [path-found (find-path-to-target target-node %)]
               (when path-found (cons current-label (seq path-found)))) ; Add current label to path if found
            current-subtrees)))) ; Stop searching once path is found

(defn reorient-graph
  "Reparents a graph based on a selected target node, keeping track of visited nodes."
  [target-node [current-label & current-subtrees :as current-tree] & visited-nodes]
  (when (seq current-tree)
    (if (= target-node current-label)
      (concat current-tree visited-nodes)
      (some #(let [reoriented-subtree (reorient-graph target-node % 
                                           (concat (remove (partial not= %) current-tree) visited-nodes))]
               (when reoriented-subtree reoriented-subtree)) ; Return reoriented subtree if found
            current-subtrees))))

(defn path-from-to
  "Determines the path from one node to another within the tree."
  [start-node end-node tree]
  (let [reoriented-tree (reorient-graph start-node tree)]
    (find-path-to-target end-node reoriented-tree))) ; Find path to end node in reoriented graph

;; Alias `reorient-graph` as `of` for compatibility with the test suite
(def of reorient-graph)
