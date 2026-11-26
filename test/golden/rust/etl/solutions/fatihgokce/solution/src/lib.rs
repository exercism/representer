use std::collections::BTreeMap;

pub fn transform(h: &BTreeMap<i32, Vec<char>>) -> BTreeMap<char, i32> {
    let mut tree=BTreeMap::new();
    for (i,vec) in h{
        for v in vec{
            let f:Vec<char>=v.to_lowercase().collect();
            tree.insert(*f.first().unwrap(), *i);
        }
    }
    tree
}
