use std::io::{BufRead, BufReader};
use std::fs::File;

pub fn read_file(filename: &str) -> impl Iterator<Item = String> {
    let f = File::open(filename).unwrap();
    BufReader::new(f)
        .lines()
        .map(|l| l.unwrap())
}

#[allow(unused)]
pub fn log_value<T: std::fmt::Debug>(value: T) -> T {
    println!("** {:?}", value);
    value
}
