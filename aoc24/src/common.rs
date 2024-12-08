use std::fmt;
use std::fs;
use std::io;
use std::io::prelude::*;
use std::num;
use std::ops;

pub fn read_file(filename: &str) -> impl Iterator<Item = String> {
    let f = fs::File::open(filename).unwrap();
    io::BufReader::new(f).lines().map(|l| l.unwrap())
}

#[allow(unused)]
pub fn log_value<T: fmt::Debug>(value: T) -> T {
    println!("** {:?}", value);
    value
}

pub struct Matrix<T> {
    data: Vec<Vec<T>>,
    rows: usize,
    cols: usize,
}

impl<T> Matrix<T> {
    pub fn new(data: Vec<Vec<T>>) -> Self {
        let rows = data.len();
        let cols = data[0].len();
        Self { data, rows, cols }
    }

    pub fn get(&self, loc: &Location) -> Option<&T> {
        self.data.get(loc.y).and_then(|row| row.get(loc.x))
    }

    pub fn at(&self, loc: &Location) -> &T {
        &self.data[loc.y][loc.x]
    }

    pub fn replace(&mut self, loc: &Location, value: T) {
        self.data[loc.y][loc.x] = value;
    }

    pub fn indices(&self) -> impl Iterator<Item = Location> + use<'_, T> {
        (0..self.rows).flat_map(move |r| (0..self.cols).map(move |c| Location::new(c, r)))
    }

    pub fn find(&self, value: T) -> Option<Location>
    where
        T: PartialEq,
    {
        self.indices().find(|loc| self.at(loc) == &value)
    }

    // pub fn iter(&self) -> impl Iterator<Item = (usize, usize, &T)> {
    //     (0..self.rows).flat_map(move |r| {
    //         (0..self.cols).map(move |c| (r, c, &self.data[r][c]))
    //     })
    // }

    pub fn rows(&self) -> usize {
        self.rows
    }

    pub fn cols(&self) -> usize {
        self.cols
    }
}

pub fn to_matrix(lines: impl Iterator<Item = String>) -> Matrix<char> {
    let data = lines.into_iter().map(|l| l.chars().collect()).collect();
    Matrix::new(data)
}

#[derive(Debug, PartialEq, Eq, Hash, Copy, Clone)]
pub struct Location {
    pub x: usize,
    pub y: usize,
}

impl Location {
    pub const fn new(x: usize, y: usize) -> Self {
        Self { x, y }
    }

    pub fn moved_by(&self, distance: Distance) -> Result<Self, num::TryFromIntError> {
        Ok(Self {
            x: usize::try_from(self.x as i32 + distance.dx)?,
            y: usize::try_from(self.y as i32 + distance.dy)?,
        })
    }

    pub fn distance_to(&self, other: Location) -> Result<Distance, num::TryFromIntError> {
        Ok(Distance::new(
            i32::try_from(self.x.abs_diff(other.x))?,
            i32::try_from(self.y.abs_diff(other.y))?,
        ))
    }
}

impl fmt::Display for Location {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}

impl ops::Sub for Location {
    type Output = Distance;

    fn sub(self, rhs: Self) -> Self::Output {
        Distance::new(
            i32::try_from(self.x).unwrap() - i32::try_from(rhs.x).unwrap(),
            i32::try_from(self.y).unwrap() - i32::try_from(rhs.y).unwrap(),
        )
    }
}

#[derive(Debug, PartialEq, Eq, Hash, Copy, Clone)]
pub struct Distance {
    pub dx: i32,
    pub dy: i32,
}

impl Distance {
    pub const fn new(dx: i32, dy: i32) -> Self {
        Self { dx, dy }
    }
}

impl fmt::Display for Distance {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "({}, {})", self.dx, self.dy)
    }
}

impl ops::Mul<i32> for Distance {
    type Output = Self;

    fn mul(self, scale: i32) -> Self::Output {
        Self::new(self.dx * scale, self.dy * scale)
    }
}

impl ops::Neg for Distance {
    type Output = Self;

    fn neg(self) -> Self::Output {
        Self::new(-self.dx, -self.dy)
    }
}
