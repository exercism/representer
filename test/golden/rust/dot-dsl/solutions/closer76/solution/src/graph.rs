pub mod graph_items {
    pub mod edge;
    pub mod node;
}

use std::collections::HashMap;

use graph_items::edge::Edge;
use graph_items::node::Node;

pub struct Graph<'a> {
    pub nodes: Vec<Node<'a>>,
    pub edges: Vec<Edge<'a>>,
    pub attrs: HashMap<String, String>,
}

impl<'a> Graph<'a> {
    pub fn new() -> Self {
        Graph {
            nodes: Vec::new(),
            edges: Vec::new(),
            attrs: HashMap::new(),
        }
    }

    pub fn with_nodes(mut self, nodes: &[Node<'a>]) -> Self {
        for node in nodes {
            self.nodes.push(node.clone());
        }
        self
    }

    pub fn with_edges(mut self, edges: &[Edge<'a>]) -> Self {
        for edge in edges {
            self.edges.push(edge.clone());
        }
        self
    }

    pub fn with_attrs(mut self, attrs: &[(&str, &str)]) -> Self {
        for &(name, value) in attrs {
            self.attrs.insert(String::from(name), String::from(value));
        }
        self
    }

    pub fn node(&self, name: &str) -> Option<&Node> {
        for node in &self.nodes {
            if node.name == name {
                return Some(node);
            }
        }
        None
    }
}
