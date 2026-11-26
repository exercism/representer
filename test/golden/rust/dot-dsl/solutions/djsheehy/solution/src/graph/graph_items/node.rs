use std::collections::HashMap;

#[derive(Clone, PartialEq, Debug)]
pub struct Node {
    pub name: String,
    pub attrs: HashMap<String, String>,
}

impl Node {
    pub fn new(name: &str) -> Self {
        Self {
            name: name.to_string(),
            attrs: HashMap::new(),
        }
    }

    pub fn with_attrs(mut self, attrs: &[(&str, &str)]) -> Self {
        self.attrs = attrs
            .into_iter()
            .map(|(a, b)| (a.to_string(), b.to_string()))
            .collect();
        self
    }

    pub fn attr(&self, name: &str) -> Option<&str> {
        self.attrs.get(name).map(AsRef::as_ref)
    }
}
