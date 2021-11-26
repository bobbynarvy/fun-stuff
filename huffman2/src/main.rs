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

fn merge_nodes(left: Node, right: Node) -> Node {
    Node {
        count: left.count + right.count,
        node_type: NodeType::Internal(Box::new(left), Box::new(right)),
    }
}

fn create_tree(mut nodes: Vec<Node>) -> Node {
    while nodes.len() > 1 {
        nodes.sort_by(|a, b| a.count.partial_cmp(&b.count).unwrap());

        let left = nodes.pop().unwrap();
        let right = nodes.pop().unwrap();

        let new_node = merge_nodes(left, right);
        nodes.push(new_node);
    }

    nodes.pop().unwrap()
}

fn encode_char(c: char, tree: &Node, acc: String) -> Option<String> {
    match &tree.node_type {
        NodeType::Leaf(x) if *x == c => return Some(acc),
        NodeType::Internal(l, r) => {
            let left = encode_char(c, &l, acc.clone() + "0");
            if left.is_some() {
                return left;
            }
            let right = encode_char(c, &r, acc.clone() + "1");
            if right.is_some() {
                return right;
            }
            None
        }
        _ => None,
    }
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

    #[test]
    fn test_create_tree() {
        let left = Node {
            count: 1,
            node_type: NodeType::Leaf('a'),
        };
        let right = Node {
            count: 2,
            node_type: NodeType::Leaf('b'),
        };
        let nodes = vec![left, right];
        let tree = create_tree(nodes);

        assert_eq!(tree.count, 3);
        match tree.node_type {
            NodeType::Internal(l, r) => {
                assert_eq!(l.node_type, NodeType::Leaf('b'));
                assert_eq!(r.node_type, NodeType::Leaf('a'));
            }
            _ => (),
        }
    }

    #[test]
    fn test_encode_char() {
        let left = Node {
            count: 1,
            node_type: NodeType::Leaf('a'),
        };
        let right = Node {
            count: 2,
            node_type: NodeType::Leaf('b'),
        };
        let tree = Node {
            count: 3,
            node_type: NodeType::Internal(Box::new(left), Box::new(right)),
        };

        let encoded = encode_char('a', &tree, String::from(""));
        assert!(encoded.is_some());
        assert_eq!(encoded.unwrap(), String::from("0"));
    }
}
