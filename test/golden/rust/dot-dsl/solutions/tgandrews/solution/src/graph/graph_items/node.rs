use std::collections::HashMap;

#[derive(Debug, PartialEq, Clone)]
pub struct Node {
    pub name: String,
    attrs: HashMap<String, String>,
}

impl Node {
    pub fn new(name: &str) -> Self {
        Node {
            name: name.to_string(),
            attrs: HashMap::new(),
        }
    }

    pub fn with_attrs(mut self, attrs: &[(&'static str, &'static str)]) -> Self {
        for (k, v) in attrs {
            self.attrs.insert(k.to_string(), v.to_string());
        }
        self
    }

    pub fn attr(&self, attr: &str) -> Option<&str> {
        self.attrs.get(attr).to_owned().map(|s| s.as_str())
    }
}
