
#[derive(Copy, Clone)]
pub struct Square {

    bits: u64
}

impl Square {

    pub fn has_possibility(&self, value: u8) -> bool {

        self.bits & 1u64 << (value - 1) != 0
    }

    pub fn get_possibility_count(&self) -> u16 {

        self.bits.count_ones() as u16
    }

    pub fn get_a_possibility(&self) -> u8 {

        for value in 1 .. 65 {

            if self.has_possibility(value) {

                return value;
            }
        }

        0
    }

    pub fn get_value(&self) -> u8 {

        if self.bits.count_ones() != 1 { return 0; }

        for index in 0 .. 63 {

            if self.bits & 1u64 << index != 0 {

                return index + 1;
            }
        }

        64
    }
}

pub struct Grid {

    pub sector_dimension: u16,
    pub dimension: u16,

    impossible_squares: u16,
    incomplete_squares: u16,

    squares: [Square; 4096]
}

impl Grid {

    fn get_square_index(&self, x: u16, y: u16) -> usize {

        (y * self.dimension + x) as usize
    }

    fn get_square_bits(&mut self, x: u16, y: u16) -> &mut u64 {

        &mut self.squares[self.get_square_index(x, y)].bits
    }

    pub fn get_square(&self, x: u16, y: u16) -> &Square {

        &self.squares[self.get_square_index(x, y)]
    }

    pub fn new(sector_dimension: u16) -> Option<Box<Self>> {

        if sector_dimension <= 1 || sector_dimension > 8 {
            
            return None;
        }

        let dimension = sector_dimension * sector_dimension;
       
        let bits = match sector_dimension {
            8 => std::u64::MAX,
            _ => (1u64 << dimension) - 1
        };

        Some(Box::new(Grid {
            sector_dimension:   sector_dimension,
            dimension:          dimension,
            impossible_squares: 0,
            incomplete_squares: dimension * dimension,
            squares:            [Square { bits: bits }; 4096]
        }))
    }

    pub fn clone(&self) -> Option<Box<Self>> {

        let mut grid = Box::new(Grid {
            sector_dimension:   0,
            dimension:          0,
            impossible_squares: 0,
            incomplete_squares: 0,
            squares:            [Square { bits: 0 }; 4096]
        });

        grid.clone_from(self);

        Some(grid)
    }

    pub fn clone_from(&mut self, source: &Self) {

        self.sector_dimension   = source.sector_dimension;
        self.dimension          = source.dimension;
        self.impossible_squares = source.impossible_squares;
        self.incomplete_squares = source.incomplete_squares;
        self.squares            = source.squares;
    }

    pub fn set_square_value(&mut self, x: u16, y: u16, value: u8) {

        let bits = self.get_square_bits(x, y);

        let possibility_count = bits.count_ones();

        *bits = 1u64 << (value - 1);

        match possibility_count {
            0 => self.impossible_squares -= 1,
            1 => {},
            _ => self.incomplete_squares -= 1
        }
    }

    pub fn remove_square_possibility(&mut self, x: u16, y: u16, value: u8) {

        let bits = self.get_square_bits(x, y);

        *bits &= !(1u64 << (value - 1));

        match bits.count_ones() {
            0 => {
                self.impossible_squares += 1;
                self.incomplete_squares += 1;
            },
            1 => self.incomplete_squares -= 1,
            _ => {}
        }
    }

    pub fn is_possible(&self) -> bool {

        self.impossible_squares == 0
    }

    pub fn is_complete(&self) -> bool {

        self.incomplete_squares == 0
    }

    fn must_be_value_by_row(&self, x: u16, y: u16, mask: u64) -> bool {

        let start = self.get_square_index(0, y);

        for index in 0 .. self.dimension as usize {

            if index == x as usize { continue; }

            if self.squares[start + index].bits & mask != 0 {

                return false;
            }
        }

        true
    }

    fn must_be_value_by_column(&self, x: u16, y: u16, mask: u64) -> bool {

        for index in 0 .. self.dimension {

            if index == y { continue; }

            if self.get_square(x, index).bits & mask != 0 {

                return false;
            }
        }

        true
    }

    fn must_be_value_by_sector(&self, x: u16, y: u16, mask: u64) -> bool {

        let x_start = x / self.sector_dimension * self.sector_dimension;
        let y_start = y / self.sector_dimension * self.sector_dimension;

        for x_index in x_start .. x_start + self.sector_dimension {

            for y_index in y_start .. y_start + self.sector_dimension {

                if x_index == x && y_index == y { continue; }

                if self.get_square(x_index, y_index).bits & mask != 0 {

                    return false;
                }
            }
        }

        true
    }

    pub fn must_be_value(&self, x: u16, y: u16, value: u8) -> bool {

        let mask = 1u64 << value - 1;

           self.must_be_value_by_row   (x, y, mask)
        || self.must_be_value_by_column(x, y, mask)
        || self.must_be_value_by_sector(x, y, mask)
    }
}

#[test]
fn new_sector_dimension_2() {

    let grid = Grid::new(2).expect("Grid::new returned None");

    assert_eq!(grid.sector_dimension, 2);
    assert_eq!(grid.dimension,        4);

    assert!( grid.is_possible());
    assert!(!grid.is_complete());

    assert_eq!(grid.get_square(0,  0).get_possibility_count(),  4);
    assert_eq!(grid.get_square(15, 15).get_possibility_count(), 4);
}

#[test]
fn new_sector_dimension_8() {

    let grid = Grid::new(8).expect("Grid::new returned None");

    assert_eq!(grid.sector_dimension, 8);
    assert_eq!(grid.dimension,        64);

    assert!( grid.is_possible());
    assert!(!grid.is_complete());

    assert_eq!(grid.get_square(0,  0).get_possibility_count(),  64);
    assert_eq!(grid.get_square(63, 63).get_possibility_count(), 64);
}

#[test]
fn set_square_value() {

    let mut grid = Grid::new(8).unwrap();

    grid.set_square_value(0,  0,  1);
    grid.set_square_value(1,  0,  2);
    grid.set_square_value(0,  1,  3);
    grid.set_square_value(63, 63, 63);

    assert_eq!(grid.get_square(0,  0).get_value(),  1);
    assert_eq!(grid.get_square(1,  0).get_value(),  2);
    assert_eq!(grid.get_square(0,  1).get_value(),  3);
    assert_eq!(grid.get_square(63, 63).get_value(), 63);
}

#[test]
fn has_possibility() {

    let mut grid = Grid::new(8).unwrap();

    grid.set_square_value(0, 0, 1);

    assert!( grid.get_square(0, 0).has_possibility(1));
    assert!(!grid.get_square(0, 0).has_possibility(2));

    grid.remove_square_possibility(0, 1, 2);

    assert!( grid.get_square(0, 1).has_possibility(1));
    assert!(!grid.get_square(0, 1).has_possibility(2));
    
    grid.set_square_value(1, 0, 3);
    grid.remove_square_possibility(1, 0, 3);

    assert!(!grid.get_square(1, 0).has_possibility(2));
    assert!(!grid.get_square(1, 0).has_possibility(3));

    grid.set_square_value(63, 63, 4);
    grid.set_square_value(63, 63, 5);

    assert!(!grid.get_square(63, 63).has_possibility(4));
    assert!( grid.get_square(63, 63).has_possibility(5));
}

#[test]
fn get_a_possibility() {

    unimplemented!();
}

#[test]
fn get_possibility_count() {

    let mut grid = Grid::new(8).unwrap();

    assert_eq!(grid.get_square(0, 1).get_possibility_count(), 64);

    grid.remove_square_possibility(0, 1, 2);
    grid.remove_square_possibility(0, 1, 2);

    assert_eq!(grid.get_square(0, 1).get_possibility_count(), 63);

    grid.set_square_value(0, 1, 2);

    assert_eq!(grid.get_square(0, 1).get_possibility_count(), 1);

    grid.remove_square_possibility(0, 1, 2);

    assert_eq!(grid.get_square(0, 1).get_possibility_count(), 0);

    grid.set_square_value(0, 1, 2);

    assert_eq!(grid.get_square(0, 1).get_possibility_count(), 1);
}

#[test]
fn get_value() {

    let mut grid = Grid::new(2).unwrap();

    assert_eq!(grid.get_square(0, 1).get_value(), 0);

    grid.remove_square_possibility(0, 1, 1);

    assert_eq!(grid.get_square(0, 1).get_value(), 0);

    grid.remove_square_possibility(0, 1, 2);
    grid.remove_square_possibility(0, 1, 4);

    assert_eq!(grid.get_square(0, 1).get_value(), 3);

    grid.set_square_value(0, 1, 1);

    assert_eq!(grid.get_square(0, 1).get_value(), 1);

    grid.remove_square_possibility(0, 1, 1);

    assert_eq!(grid.get_square(0, 1).get_value(), 0);
}

#[test]
fn clone() {

    let mut gridA = Grid::new(8).unwrap();

    gridA.set_square_value(62, 63, 64);
    gridA.remove_square_possibility(62, 63, 64);

    let gridB = gridA.clone();

    assert_eq!(gridB.sector_dimension, 8);
    assert_eq!(gridB.dimension, 64);

    assert!(!gridB.is_complete());
    assert!(!gridB.is_possible());

    assert_eq!(gridB.get_square(0,  0).get_possibility_count(),  64);
    assert_eq!(gridB.get_square(62, 63).get_possibility_count(), 0);
}

#[test]
fn clone_from() {

    let mut gridA = Grid::new(8).unwrap();
    let mut gridB = Grid::new(2).unwrap();

    gridA.set_square_value(62, 63, 64);
    gridA.remove_square_possibility(62, 63, 64);

    for x_index in 0..4 {

        for y_index in 0..4 {

            gridB.set_square_value(x_index, y_index, 1);
        }
    }

    gridB.clone_from(gridA);

    assert_eq!(gridB.sector_dimension, 8);
    assert_eq!(gridB.dimension, 64);

    assert!(!gridB.is_complete());
    assert!(!gridB.is_possible());

    assert_eq!(gridB.get_square(0,  0).get_possibility_count(),  64);
    assert_eq!(gridB.get_square(62, 63).get_possibility_count(), 0);
    assert_eq!(gridA.get_square(62, 63).get_possibility_count(), 0);
}

#[test]
fn remove_square_possibility() {

    unimplemented!();
}

#[test]
fn is_possible() {

    unimplemented!();
}

#[test]
fn is_complete() {

    unimplemented!();
}

#[test]
fn must_be_value() {

    unimplemented!();
}