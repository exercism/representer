use std::collections::HashMap;

#[derive(Debug)]
pub struct Edge<'a> {
    pub from: &'a str,
    pub to: &'a str,
    pub attrs: HashMap<&'a str, &'a str>,
}

impl<'a> Edge<'a> {
    pub fn new(from: &'a str, to: &'a str) -> Self {
        Edge {
            from,
            to,
            attrs: HashMap::new(),
        }
    }

    pub fn with_attrs(mut self, attrs: &[(&'a str, &'a str)]) -> Self {
        for &(name, value) in attrs {
            self.attrs.insert(name, value);
        }
        self
    }

    pub fn attr(&self, name: &str) -> Option<&'a str> {
        self.attrs.get(name).cloned()
    }
}

impl<'a> PartialEq for Edge<'a> {
    fn eq(&self, others: &Self) -> bool {
        self.from == others.from && self.to == others.to && self.attrs == others.attrs
    }
}

impl<'a> Clone for Edge<'a> {
    fn clone(&self) -> Self {
        Edge {
            from: self.from,
            to: self.to,
            attrs: self.attrs.clone(),
        }
    }
}
