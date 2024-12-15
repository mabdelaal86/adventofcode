use std::fmt;
use std::fs;
use std::io;
use std::io::prelude::*;

#[allow(unused)]
pub fn log_value<T: fmt::Debug>(value: T) -> T {
    println!("** {:?}", value);
    value
}

fn file_name(day: u8) -> String {
    format!("data/day{:02}.txt", day)
}

pub fn read_lines(day: u8) -> impl Iterator<Item = String> {
    let f = fs::File::open(file_name(day)).unwrap();
    io::BufReader::new(f).lines().map(|l| l.unwrap())
}

pub fn read_all(day: u8) -> String {
    let mut f = fs::File::open(file_name(day)).unwrap();
    let mut buffer = String::new();
    f.read_to_string(&mut buffer).unwrap();
    buffer
}
