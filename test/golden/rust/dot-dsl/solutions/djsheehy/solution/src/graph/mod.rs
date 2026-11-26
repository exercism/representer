pub mod graph_items;

use graph_items::edge::Edge;
use graph_items::node::Node;

use std::collections::HashMap;

#[derive(Clone, Debug, Default, PartialEq)]
pub struct Graph {
    pub attrs: HashMap<String, String>,
    pub edges: Vec<Edge>,
    pub nodes: Vec<Node>,
    lookup: HashMap<String, Node>,
}

impl Graph {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn with_attrs(mut self, attrs: &[(&str, &str)]) -> Self {
        self.attrs = attrs
            .iter()
            .map(|(a, b)| (a.to_string(), b.to_string()))
            .collect();
        self
    }

    pub fn with_nodes(mut self, nodes: &[Node]) -> Self {
        self.nodes = nodes.to_vec();
        self.lookup = nodes
            .iter()
            .map(|node| (node.name.clone(), node.clone()))
            .collect();
        self
    }

    pub fn with_edges(mut self, edges: &[Edge]) -> Self {
        self.edges = edges.to_vec();
        self
    }

    pub fn node(&self, name: &str) -> Option<&Node> {
        self.lookup.get(name)
    }
}
