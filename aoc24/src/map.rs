use std::num;

use euclid;

pub type Location = euclid::default::Point2D<usize>;

pub type Distance = euclid::default::Vector2D<i32>;

pub fn moved_by(location: Location, distance: Distance) -> Result<Location, num::TryFromIntError> {
    Ok(Location::new(
        usize::try_from(location.x as i32 + distance.x)?,
        usize::try_from(location.y as i32 + distance.y)?,
    ))
}

pub fn distance_to(location: Location, other: Location) -> Result<Distance, num::TryFromIntError> {
    Ok(Distance::new(
        i32::try_from(location.x.abs_diff(other.x))?,
        i32::try_from(location.y.abs_diff(other.y))?,
    ))
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
