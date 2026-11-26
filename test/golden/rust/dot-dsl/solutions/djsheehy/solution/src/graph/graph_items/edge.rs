use std::collections::HashMap;

#[derive(Clone, Debug, PartialEq)]
pub struct Edge {
    pub start: String,
    pub end: String,
    pub attrs: HashMap<String, String>,
}

impl Edge {
    pub fn new(start: &str, end: &str) -> Self {
        Self {
            start: start.to_string(),
            end: end.to_string(),
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
