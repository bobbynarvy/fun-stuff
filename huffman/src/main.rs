use std::collections::HashMap;

#[derive(Debug)]
struct Node {
    freq: u16,
    value: Option<char>,
    left: Option<Box<Node>>,
    right: Option<Box<Node>>,
}

impl Node {
    fn new(freq: u16, value: Option<char>) -> Node {
        Node {
            freq,
            value,
            left: None,
            right: None,
        }
    }
}

fn get_nodes(chars: &Vec<char>) -> Vec<Node> {
    let mut frequencies: HashMap<char, u16> = HashMap::new();
    let mut nodes = vec![];

    for char in chars {
        frequencies
            .entry(*char)
            .and_modify(|c| *c += 1)
            .or_insert(1);
    }

    for (c, f) in frequencies.into_iter() {
        nodes.push(Node::new(f, Some(c)));
    }

    nodes
}

fn merge_nodes(mut nodes: Vec<Node>) -> Node {
    while nodes.len() > 1 {
        nodes.sort_by(|a, b| a.freq.partial_cmp(&b.freq).unwrap());

        let left = nodes.remove(0);
        let right = nodes.remove(0);

        let mut new_node = Node::new(left.freq + right.freq, None);
        new_node.left = Some(Box::new(left));
        new_node.right = Some(Box::new(right));

        nodes.push(new_node)
    }

    nodes.remove(0)
}

fn main() {
    let s = "Hello, world!";
    let chars = s.chars().collect();
    let nodes = get_nodes(&chars);
    let node = merge_nodes(nodes);

    println!("{:#?}", node)
}
