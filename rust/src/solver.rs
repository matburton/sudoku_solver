
use super::grid::{ * };

#[derive(Default)]
pub struct Counters {

    pub grid_splits:      u64,
    pub impossible_grids: u64,
    pub grids_lost:       u64,
    pub solutions:        u64
}

pub struct GridStack {

    stack: std::collections::VecDeque<Box<Grid>>
}

impl GridStack {

    pub fn new(sector_dimension: u16) -> Option<Self> {

        match Grid::new(sector_dimension) {
            None => None,
            Some(grid) => {

                let mut stack = std::collections::VecDeque::new();

                stack.push_front(grid);

                Some(GridStack { stack: stack })
            }
        }
    }

    pub fn len(&self) -> usize {

        self.stack.len()
    }

    pub fn peek_front(&self) -> Option<&Grid> {

        match self.stack.front() {
            None => None,
            Some(grid) => Some(grid)
        }
    }

    pub fn drop_front(&mut self) {

        self.stack.pop_front();
    }

    fn attach_to_front_if_possible(&mut self,
                                   grid: Box<Grid>,
                                   counters: &mut Counters) {

        if !grid.is_possible() {

            counters.impossible_grids += 1;

            return;
        }

        self.stack.push_front(grid);
    }

    fn split_first_grid_to_front(&mut self, counters: &mut Counters) {

        let mut grid = match self.stack.pop_front() {
            Some(grid) => grid,
            None => return
        };

        let mut best_count = 0;

        let mut x_best = 0;
        let mut y_best = 0;

        for y in 0 .. grid.dimension {

            for x in 0 .. grid.dimension {

                let count = grid.get_square(x, y)
                                .get_possibility_count();
                if count > 1 {

                    if best_count == 0 || count < best_count {

                        best_count = count;

                        x_best = x;
                        y_best = y;
                    }
                }
            }
        }

        let possibility = grid.get_square(x_best, y_best)
                              .get_a_possibility();
        
        let mut clone = grid.clone();

        if clone.is_none() {

            counters.grids_lost += 1;

            if let Some(mut victim) = self.stack.pop_back() {

                victim.clone_from(&grid);

                clone = Some(victim);
            }
        }

        if let Some(mut clone) = clone {

            counters.grid_splits += 1;

            remove_possibility_at(&mut clone, x_best, y_best, possibility);

            self.attach_to_front_if_possible(clone, counters);
        }

        set_value_at(&mut grid, x_best, y_best, possibility);

        self.attach_to_front_if_possible(grid, counters);
    }
}

fn remove_possibility_at(grid: &mut Grid, x: u16, y: u16, value: u8) {

    if !grid.get_square(x, y).has_possibility(value) { return; }

    grid.remove_square_possibility(x, y, value);

    let value = grid.get_square(x, y).get_value();

    if value != 0 {

        remove_possibilities_related_to(grid, x, y, value);
    }
}

fn remove_possibilities_related_to(grid: &mut Grid, x: u16, y: u16, value: u8) {

    for x_index in 0 .. grid.dimension {

        if x_index != x {

            remove_possibility_at(grid, x_index, y, value);
        }
    }

    for y_index in 0 .. grid.dimension {

        if y_index != y {

            remove_possibility_at(grid, x, y_index, value);
        }
    }

    let sector_dimension = grid.sector_dimension;

    let x_start = x / sector_dimension * sector_dimension;
    let y_start = y / sector_dimension * sector_dimension;

    for y_index in y_start .. y_start + sector_dimension {

        for x_index in x_start .. x_start + sector_dimension {

            if x_index != x && y_index != y {

                remove_possibility_at(grid, x_index, y_index, value);
            }
        }
    }
}

pub fn set_value_at(grid: &mut Grid, x: u16, y: u16, value: u8) {

    grid.set_square_value(x, y, value);

    remove_possibilities_related_to(grid, x, y, value);
}

fn get_deduced_value_at(grid: &Grid, x: u16, y: u16) -> u8 {

    let square = grid.get_square(x, y);

    if square.get_possibility_count() > 1 {

        for value in 1 ..= grid.dimension as u8 {

            if square.has_possibility(value)
               && grid.must_be_value(x, y, value) {

                return value;
            }
        }
    }

    0
}

fn refine_grid(grid: &mut Grid) {

    let mut x = 0;
    let mut y = 0;

    let mut x_last = 0;
    let mut y_last = 0;

    loop {

        let value = get_deduced_value_at(grid, x, y);

        if value != 0 {

            set_value_at(grid, x, y, value);

            if !grid.is_possible() { return; }

            x_last = x;
            y_last = y;
        }

        match x < grid.dimension - 1 {
            true  => x += 1,
            false => {

                x = 0;
                y = (y + 1) % grid.dimension;
            }
        }

        if x == x_last && y == y_last { return; }
    }
}

pub fn advance_solving(grid_stack: &mut GridStack,
                       counters: &mut Counters) {

    match grid_stack.stack.front() {
        None => return,
        Some(grid) => {

            if !grid.is_possible() {

                counters.impossible_grids += 1;

                grid_stack.drop_front();
            }
        }
    };

    match grid_stack.stack.front_mut() {
        None => return,
        Some(grid) => {
            
            refine_grid(grid);

            if !grid.is_complete() && grid.is_possible() {

                grid_stack.split_first_grid_to_front(counters);
            }
        }
    };
}