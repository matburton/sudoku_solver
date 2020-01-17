
pub struct Grid {

    pub sector_dimension: u16,
    pub dimension: u16,

    impossible_squares: u16,
    incomplete_squares: u16,

    squares: [u64; 4096]
}

impl Grid {

    pub fn new(sector_dimension: u16) -> Option<Box<Grid>> {

        if sector_dimension <= 1 || sector_dimension > 8 {
            
            return None;
        }

        let dimension = sector_dimension * sector_dimension;

        let square = match sector_dimension {
            8 => std::u64::MAX,
            _ => (1u64 << dimension) - 1
        };

        Some(Box::new(Grid {
            sector_dimension:   sector_dimension,
            dimension:          dimension,
            impossible_squares: 0,
            incomplete_squares: dimension * dimension,
            squares:            [square; 4096]
        }))
    }
}

#[test]
fn new_sector_dimension_2() {

    let grid = Grid::new(2);

    unimplemented!();
}

#[test]
fn new_sector_dimension_8() {

    let grid = Grid::new(8);

    unimplemented!();
}