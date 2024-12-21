mod data;
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
mod day09b;
mod map;
mod play_ground;

fn main() {
    let day = std::env::args().nth(1).expect("no day given");
    let day = day.parse::<u8>().expect("day is not a number");

    let part = std::env::args().nth(2).expect("no part given");

    println!("Res: {}", process(day, part));
}

fn process(day: u8, part: String) -> String {
    let puzzle = format!("day{:02}{}", day, part);

    match puzzle.as_str() {
        "day00x" => day00x::process(data::read_lines(day)).to_string(),
        "day01a" => day01a::process(data::read_lines(day)).to_string(),
        "day01b" => day01b::process(data::read_lines(day)).to_string(),
        "day02a" => day02a::process(data::read_lines(day)).to_string(),
        "day02b" => day02b::process(data::read_lines(day)).to_string(),
        "day03a" => day03a::process(data::read_lines(day)).to_string(),
        "day03b" => day03b::process(data::read_lines(day)).to_string(),
        "day04a" => day04a::process(data::read_lines(day)).to_string(),
        "day04b" => day04b::process(data::read_lines(day)).to_string(),
        "day05a" => day05a::process(data::read_lines(day)).to_string(),
        "day05b" => day05b::process(data::read_lines(day)).to_string(),
        "day06a" => day06a::process(data::read_lines(day)).to_string(),
        "day06b" => day06b::process(data::read_lines(day)).to_string(),
        "day07a" => day07a::process(data::read_lines(day)).to_string(),
        "day07b" => day07b::process(data::read_lines(day)).to_string(),
        "day08a" => day08a::process(data::read_lines(day)).to_string(),
        "day08b" => day08b::process(data::read_lines(day)).to_string(),
        "day09a" => day09a::process(data::read_all(day)).to_string(),
        "day09b" => day09b::process(data::read_all(day)).to_string(),
        _ => panic!("unknown puzzle: {}", puzzle),
    }
}
