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

pub struct Matrix<T> {
    data: Vec<Vec<T>>,
    rows: usize,
    cols: usize,
}

impl<T> Matrix<T> where Vec<T>: FromIterator<char> {
    pub fn new(data: Vec<Vec<T>>) -> Self {
        let rows = data.len();
        let cols = data[0].len();
        Self { data, rows, cols }
    }

    pub fn get(&self, rows: usize, cols: usize) -> Option<&T> {
        self.data.get(rows).and_then(|row| row.get(cols))
    }

    pub fn at(&self, rows: usize, cols: usize) -> &T {
        &self.data[rows][cols]
    }

    pub fn indices(&self) -> impl Iterator<Item = (usize, usize)> + use<'_, T> {
        (0..self.rows).flat_map(move |r| {
            (0..self.cols).map(move |c| (r, c))
        })
    }

    // pub fn iter(&self) -> impl Iterator<Item = (usize, usize, &T)> {
    //     (0..self.rows).flat_map(move |r| {
    //         (0..self.cols).map(move |c| (r, c, &self.data[r][c]))
    //     })
    // }
    // 
    // pub fn rows(&self) -> usize {
    //     self.rows
    // }
    // 
    // pub fn cols(&self) -> usize {
    //     self.cols
    // }
}

pub fn to_matrix(lines: impl IntoIterator<Item = String>) -> Matrix<char> {
    let data = lines.into_iter()
        .map(|l| l.chars().collect())
        .collect();
    Matrix::new(data)
}
