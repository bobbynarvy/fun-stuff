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
        nodes.sort_by(|a, b| b.count.partial_cmp(&a.count).unwrap());

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

pub fn encode(text: String) -> (String, Vec<Encoding>) {
    let nodes = init_nodes(text.clone());
    let tree = create_tree(nodes);
    let mut encoding_map: HashMap<char, String> = HashMap::new();
    let mut code = String::new();
    let mut encodings: Vec<Encoding> = vec![];

    for c in text.chars() {
        match encoding_map.get(&c) {
            Some(_) => {
                let char_code = encoding_map.get(&c).unwrap();
                code.push_str(char_code.as_str());
            }
            None => {
                let char_code = encode_char(c, &tree, String::from("0")).unwrap();
                code.push_str(char_code.as_str());
                encoding_map.insert(c, char_code.clone());
                encodings.push((c, char_code));
            }
        }
    }

    (code, encodings)
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

    fn create_leaf_node(c: char, count: i8) -> Node {
        Node {
            count: count,
            node_type: NodeType::Leaf(c),
        }
    }

    #[test]
    fn test_create_tree() {
        let left = create_leaf_node('a', 1);
        let right = create_leaf_node('b', 2);
        let nodes = vec![left, right];
        let tree = create_tree(nodes);

        assert_eq!(tree.count, 3);
        match tree.node_type {
            NodeType::Internal(l, r) => {
                assert_eq!(l.node_type, NodeType::Leaf('a'));
                assert_eq!(r.node_type, NodeType::Leaf('b'));
            }
            _ => (),
        }
    }

    #[test]
    fn test_encode_char() {
        let n1 = create_leaf_node('a', 2);
        let n2 = create_leaf_node('b', 3);
        let n3 = create_leaf_node('c', 4);
        let tree = create_tree(vec![n1, n2, n3]);

        let encoded = encode_char('a', &tree, String::from("0"));
        assert!(encoded.is_some());
        assert_eq!(encoded.unwrap(), String::from("010"));
        let encoded2 = encode_char('c', &tree, String::from("0"));
        assert!(encoded2.is_some());
        assert_eq!(encoded2.unwrap(), String::from("00"));
    }

    #[test]
    fn test_encode() {
        let (code, encodings) = encode(String::from("aabbbcccc"));
        for encoding in encodings {
            match encoding {
                ('a', string) => assert_eq!(string, String::from("010")),
                ('b', string) => assert_eq!(string, String::from("011")),
                ('c', string) => assert_eq!(string, String::from("00")),
                _ => (),
            }
        }
        assert_eq!(code, "01001001101101100000000");
    }
}
