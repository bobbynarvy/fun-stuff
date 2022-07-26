use std::collections::HashMap;
use std::io::{Read, Write};
use std::net::{TcpListener, TcpStream};
use std::thread;
use std::sync::{Arc, Mutex};
use std::str;

#[derive(Debug)]
enum Request {
    Get(String),
    Set(String, String),
}

type KVStore = HashMap<String, String>;

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

fn process_request(request: Request, kv: &mut KVStore) -> Result<String, &str> {
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

fn send_response(stream: &mut TcpStream, response: &Result<String, &str>) {
    match response {
        Ok(r) => {
            stream.write(r.as_bytes()).unwrap();
            stream.flush().unwrap();
        }
        Err(e) => {
            let mut err_msg = String::from("Error: ");
            err_msg.push_str(e);

            stream.write(err_msg.as_bytes()).unwrap();
            stream.flush().unwrap();
        }
    }
}

fn handle_stream(stream: &mut TcpStream, kv: &mut KVStore) -> std::io::Result<()> {
    let mut buffer = [0; 128];
    let s_size = stream.read(&mut buffer)?;
    let payload = str::from_utf8(&buffer[..s_size]);
    let request = match payload {
        Ok(p) => parse_payload(p),
        Err(_) => Err("Payload error."),
    };
    let response = request.and_then(|req| process_request(req, kv));

    println!("{:?}", response);
    send_response(stream, &response);
    Ok(())
}

fn main() -> std::io::Result<()> {
    let listener = TcpListener::bind("127.0.0.1:8080")?;
    let kv = HashMap::<String, String>::new();
    let akv = Arc::new(Mutex::new(kv));
    let mut handles = vec![];

    for stream in listener.incoming() {
        let akv = Arc::clone(&akv);
        let handle = thread::spawn(move || {
            let mut kv = akv.lock().unwrap();
            match stream {
                Err(e) => println!("{}", e),
                Ok(mut s) => handle_stream(&mut s, &mut kv).unwrap(),
            } 
        });

        handles.push(handle)        
    }

    for handle in handles {
        handle.join().unwrap();
    }
    
    Ok(())
}
