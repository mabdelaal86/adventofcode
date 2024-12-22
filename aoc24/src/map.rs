use euclid::default::{Point2D, Vector2D};

pub type Location = Point2D<i32>;
pub type ValidLocation = Point2D<usize>;

pub type Distance = Vector2D<i32>;

pub fn moved_by(location: ValidLocation, distance: Distance) -> Location {
    location.to_i32() + distance
}

pub trait MapTrait {
    fn rows(&self) -> usize;
    fn cols(&self) -> usize;

    fn validate_loc(&self, loc: &Location) -> Option<ValidLocation> {
        let x = usize::try_from(loc.x).ok()?;
        let y = usize::try_from(loc.y).ok()?;
        if x < self.cols() && y < self.rows() {
            Some(Point2D::new(x, y))
        } else {
            None
        }
    }
}

pub struct Matrix<T> {
    data: Vec<Vec<T>>,
    rows: usize,
    cols: usize,
}

impl<T> MapTrait for Matrix<T> {
    fn rows(&self) -> usize { self.rows }
    fn cols(&self) -> usize { self.cols }
}

impl<T> Matrix<T> {
    pub fn new(data: Vec<Vec<T>>) -> Self {
        let rows = data.len();
        let cols = data[0].len();
        Self { data, rows, cols }
    }

    pub fn get(&self, loc: &Location) -> Option<&T> {
        let loc = self.validate_loc(loc)?;
        self.data.get(loc.y).and_then(|row| row.get(loc.x))
    }

    pub fn at(&self, loc: &ValidLocation) -> &T {
        &self.data[loc.y][loc.x]
    }

    pub fn replace(&mut self, loc: &ValidLocation, value: T) {
        self.data[loc.y][loc.x] = value;
    }

    pub fn indices(&self) -> impl Iterator<Item = ValidLocation> + use<'_, T> {
        (0..self.rows).flat_map(move |r| {
            (0..self.cols).map(move |c| {
                ValidLocation::new(c, r)
            })
        })
    }

    pub fn find(&self, value: T) -> Option<ValidLocation>
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
}

pub fn to_matrix(lines: impl Iterator<Item = String>) -> Matrix<char> {
    let data = lines.into_iter().map(|l| l.chars().collect()).collect();
    Matrix::new(data)
}
