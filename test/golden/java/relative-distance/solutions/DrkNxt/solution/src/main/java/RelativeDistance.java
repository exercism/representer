import java.util.*;

public class RelativeDistance {
    private Map<String, List<String>> familyTree;
    
    public RelativeDistance(Map<String, List<String>> familyTree) {
        this.familyTree = familyTree;
    }
    
    public int degreeOfSeparation(String personA, String personB) {
        if (personA.equals(personB)) {
            return 0;
        }
        
        Map<String, Set<String>> graph = buildBidirectionalGraph();
        
        if (!graph.containsKey(personA) || !graph.containsKey(personB)) {
            return -1;
        }
        
        Queue<String> queue = new LinkedList<>();
        Map<String, Integer> distances = new HashMap<>();
        
        queue.offer(personA);
        distances.put(personA, 0);
        
        while (!queue.isEmpty()) {
            String current = queue.poll();
            int currentDistance = distances.get(current);
            
            for (String neighbor : graph.get(current)) {
                if (!distances.containsKey(neighbor)) {
                    int newDistance = currentDistance + 1;
                    distances.put(neighbor, newDistance);
                    queue.offer(neighbor);
                    
                    if (neighbor.equals(personB)) {
                        return newDistance;
                    }
                }
            }
        }
        
        return -1;
    }
    
    private Map<String, Set<String>> buildBidirectionalGraph() {
        Map<String, Set<String>> graph = new HashMap<>();
        
        for (String parent : familyTree.keySet()) {
            graph.putIfAbsent(parent, new HashSet<>());
            for (String child : familyTree.get(parent)) {
                graph.putIfAbsent(child, new HashSet<>());
            }
        }
        
        for (Map.Entry<String, List<String>> entry : familyTree.entrySet()) {
            String parent = entry.getKey();
            List<String> children = entry.getValue();
            
            for (String child : children) {
                graph.get(parent).add(child);
                graph.get(child).add(parent);
            }
            
            for (int i = 0; i < children.size(); i++) {
                for (int j = i + 1; j < children.size(); j++) {
                    String child1 = children.get(i);
                    String child2 = children.get(j);
                    graph.get(child1).add(child2);
                    graph.get(child2).add(child1);
                }
            }
        }
        
        return graph;
    }
}