mod common;
mod day00x;
mod day01a;
mod day01b;
mod day02a;
mod day02b;
mod day03a;
mod day03b;
mod day04a;
mod day04b;
mod day05a;
mod day05b;
mod day06a;
mod day06b;
mod day07a;
mod day07b;
mod day08a;
mod day08b;

fn main() {
    let puzzle = std::env::args().nth(1).expect("no puzzle given");

    match puzzle.as_str() {
        "day00x" => day00x::main(),
        "day01a" => day01a::main(),
        "day01b" => day01b::main(),
        "day02a" => day02a::main(),
        "day02b" => day02b::main(),
        "day03a" => day03a::main(),
        "day03b" => day03b::main(),
        "day04a" => day04a::main(),
        "day04b" => day04b::main(),
        "day05a" => day05a::main(),
        "day05b" => day05b::main(),
        "day06a" => day06a::main(),
        "day06b" => day06b::main(),
        "day07a" => day07a::main(),
        "day07b" => day07b::main(),
        "day08a" => day08a::main(),
        "day08b" => day08b::main(),
        _ => panic!("Invalid puzzle name"),
    };
}
