use std::collections::HashMap;

#[derive(Debug)]
pub struct Node<'a> {
    pub name: &'a str,
    pub attrs: HashMap<String, String>,
}

impl<'a> Node<'a> {
    pub fn new(name: &'a str) -> Self {
        Node {
            name,
            attrs: HashMap::new(),
        }
    }

    pub fn with_attrs(mut self, attrs: &[(&str, &str)]) -> Self {
        for &(name, value) in attrs {
            self.attrs.insert(String::from(name), String::from(value));
        }
        self
    }

    pub fn attr(&self, key: &str) -> Option<&str> {
        self.attrs.get(key).map(|k| &k[..])
    }
}

impl PartialEq for Node<'_> {
    fn eq(&self, others: &Self) -> bool {
        self.name == others.name && self.attrs == others.attrs
    }
}

impl Clone for Node<'_> {
    fn clone(&self) -> Self {
        Node {
            name: self.name,
            attrs: self.attrs.clone(),
        }
    }
}
