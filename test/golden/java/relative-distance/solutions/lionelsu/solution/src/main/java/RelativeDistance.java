import java.util.*;

class RelativeDistance {
    private final Map<String, Set<String>> graph;

    RelativeDistance(Map<String, List<String>> familyTree) {
        this.graph = new HashMap<>();
        for (Map.Entry<String, List<String>> entry : familyTree.entrySet()) {
            String parent = entry.getKey();
            List<String> children = entry.getValue();

            for (String child : children) {
                graph.computeIfAbsent(parent, k -> new HashSet<>()).add(child);
                graph.computeIfAbsent(child, k -> new HashSet<>()).add(parent);
                for (String sibling : children) {
                    if (!sibling.equals(child)) {
                        graph.get(child).add(sibling);
                    }
                }
            }
        }
    }

    int degreeOfSeparation(String personA, String personB) {
        Queue<String> queue = new ArrayDeque<>();
        Map<String, Integer> distanceMap = new HashMap<>();
        queue.add(personA);
        distanceMap.put(personA, 0);

        while (!queue.isEmpty()) {
            String current = queue.poll();
            int currentDistance = distanceMap.get(current);

            for (String relative : graph.getOrDefault(current, Set.of())) {
                if (!distanceMap.containsKey(relative)) {
                    distanceMap.put(relative, currentDistance + 1);
                    queue.add(relative);
                }
            }
        }
        return distanceMap.getOrDefault(personB, -1);
    }
}