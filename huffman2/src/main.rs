use std::collections::HashMap;

type Encoding = (char, String);

#[derive(PartialEq, Debug)]
enum NodeType {
    Internal(Box<Node>, Box<Node>),
    Leaf(char),
}

#[derive(PartialEq, Debug)]
struct Node {
    count: i8,
    node_type: NodeType,
}

fn init_nodes(text: String) -> Vec<Node> {
    let mut char_counts = HashMap::new();
    let mut nodes = vec![];

    for c in text.chars() {
        let char_count = char_counts.entry(c).or_insert(0);
        *char_count += 1;
    }
    for (c, count) in char_counts.iter() {
        let node = Node {
            count: *count,
            node_type: NodeType::Leaf(*c),
        };
        nodes.push(node);
    }
    nodes
}

fn main() {
    println!("Hello, world!");
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_init_nodes() {
        let nodes = init_nodes(String::from("Hello"));

        assert_eq!(nodes.len(), 4);
        for node in nodes.iter() {
            match node.node_type {
                NodeType::Leaf(c) => match c {
                    'H' => assert_eq!(node.count, 1),
                    'l' => assert_eq!(node.count, 2),
                    _ => (),
                },
                _ => (),
            }
        }
    }
}
