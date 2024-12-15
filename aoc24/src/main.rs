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
mod day09a;

fn main() {
    let puzzle = std::env::args().nth(1).expect("no puzzle given");
    let data_file = format!("data/{}.txt", &puzzle[0..5]);

    match puzzle.as_str() {
        "day00x" => day00x::main(&data_file),
        "day01a" => day01a::main(&data_file),
        "day01b" => day01b::main(&data_file),
        "day02a" => day02a::main(&data_file),
        "day02b" => day02b::main(&data_file),
        "day03a" => day03a::main(&data_file),
        "day03b" => day03b::main(&data_file),
        "day04a" => day04a::main(&data_file),
        "day04b" => day04b::main(&data_file),
        "day05a" => day05a::main(&data_file),
        "day05b" => day05b::main(&data_file),
        "day06a" => day06a::main(&data_file),
        "day06b" => day06b::main(&data_file),
        "day07a" => day07a::main(&data_file),
        "day07b" => day07b::main(&data_file),
        "day08a" => day08a::main(&data_file),
        "day08b" => day08b::main(&data_file),
        "day09a" => day09a::main(&data_file),
        _ => panic!("Invalid puzzle name"),
    };
}
