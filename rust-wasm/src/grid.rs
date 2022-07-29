
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

    squares: std::vec::Vec<Square>
}

impl Grid {

    fn get_square_index(&self, x: u16, y: u16) -> usize {

        (y * self.dimension + x) as usize
    }

    fn get_square_bits(&mut self, x: u16, y: u16) -> &mut u64 {

        let square_index = self.get_square_index(x, y);

        &mut self.squares[square_index].bits
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

        let square_count = dimension * dimension;

        Some(Box::new(Grid {
            sector_dimension:   sector_dimension,
            dimension:          dimension,
            impossible_squares: 0,
            incomplete_squares: square_count,
            squares: vec![Square { bits: bits }; square_count as usize]
        }))
    }

    pub fn clone(&self) -> Option<Box<Self>> {

        Some(Box::new(Grid {
            sector_dimension:   self.sector_dimension,
            dimension:          self.dimension,
            impossible_squares: self.impossible_squares,
            incomplete_squares: self.incomplete_squares,
            squares:            self.squares.clone()
        }))
    }

    pub fn clone_from(&mut self, source: &Self) {

        self.sector_dimension   = source.sector_dimension;
        self.dimension          = source.dimension;
        self.impossible_squares = source.impossible_squares;
        self.incomplete_squares = source.incomplete_squares;
        self.squares            = source.squares.clone();
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