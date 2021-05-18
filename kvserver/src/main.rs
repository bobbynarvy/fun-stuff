use std::io::Read;
use std::net::TcpListener;
use std::str;

#[derive(Debug)]
enum Request {
    Get(&'static str),
    Set(&'static str, &'static str),
}

fn parse_payload(payload: &'static str) -> Result<Request, &'static str> {
    let mut parsed = payload.split_whitespace();
    let op = match parsed.next() {
        Some("GET") => Ok("GET"),
        Some("SET") => Ok("SET"),
        _ => return Err("Request invalid"),
    };

    let key = match parsed.next() {
        Some(s) => s,
        None => return Err("No key set.")
    };

    op.and_then(|o| match o {
        "GET" => Ok(Request::Get(key)),
        "SET" => {
            match parsed.next() {
                Some(s) => Ok(Request::Set(key, s)),
                None => Err("No value set."),
            }
        }
        _ => Err("Error parsing payload.")
    })
}

fn main() -> std::io::Result<()> {
    let listener = TcpListener::bind("127.0.0.1:8080")?;

    for stream in listener.incoming() {
        match stream {
            Err(e) => println!("{}", e),
            Ok(mut s) => {
                let mut buffer = [0; 128];
                let s_size = s.read(&mut buffer)?;
                let payload = str::from_utf8(&buffer[..s_size]);
                let request = match payload {
                    Ok(p) => parse_payload(p),
                    Err(_) => Err("Payload error.")
                };

                println!("{:?}", request)
            }
        }
    }
    Ok(())
}
