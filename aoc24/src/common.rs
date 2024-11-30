use std::io::{BufRead, BufReader};
use std::fs::File;

pub fn read_file(filename: &str) -> impl Iterator<Item = String> {
    let f = File::open(filename).unwrap();
    BufReader::new(f)
        .lines()
        .map(|l| l.unwrap())
}

// pub fn log_value<T>(value: T) {
//     println!("** {:?}", value);
//     value
// }
