use std::collections::HashMap;
use std::io::Read;
use std::net::TcpListener;
use std::str;

#[derive(Debug)]
enum Request {
    Get(String),
    Set(String, String),
}

fn parse_payload(payload: &str) -> Result<Request, &'static str> {
    let mut parsed = payload.split_whitespace();
    let op = match parsed.next() {
        Some("GET") => Ok("GET"),
        Some("SET") => Ok("SET"),
        _ => return Err("Request invalid"),
    };

    let key = match parsed.next() {
        Some(s) => s,
        None => return Err("No key set."),
    };

    op.and_then(|o| match o {
        "GET" => Ok(Request::Get(String::from(key))),
        "SET" => match parsed.next() {
            Some(s) => Ok(Request::Set(String::from(key), String::from(s))),
            None => Err("No value set."),
        },
        _ => Err("Error parsing payload."),
    })
}

fn process_request(request: Request, kv: &mut HashMap<String, String>) -> Result<String, &str> {
    match request {
        Request::Get(s) => match kv.get(&s) {
            Some(v) => Ok(v.to_string()),
            None => Err("Value not found."),
        },
        Request::Set(k, v) => {
            kv.entry(k).and_modify(|val| *val = v.clone()).or_insert(v);
            Ok(String::from("Value updated."))
        }
    }
}

fn main() -> std::io::Result<()> {
    let listener = TcpListener::bind("127.0.0.1:8080")?;
    let mut kv = HashMap::<String, String>::new();

    for stream in listener.incoming() {
        match stream {
            Err(e) => println!("{}", e),
            Ok(mut s) => {
                let mut buffer = [0; 128];
                let s_size = s.read(&mut buffer)?;
                let payload = str::from_utf8(&buffer[..s_size]);
                let request = match payload {
                    Ok(p) => parse_payload(p),
                    Err(_) => Err("Payload error."),
                };
                let response = request.and_then(|req| process_request(req, &mut kv));

                println!("{:?}", response)
            }
        }
    }
    Ok(())
}
