
use wasm_bindgen::prelude::*;

mod grid;
mod solver;

#[global_allocator]
static ALLOC: wee_alloc::WeeAlloc = wee_alloc::WeeAlloc::INIT;

fn step<'a>(grid_stack: &'a mut solver::GridStack,
            counters: &mut solver::Counters) -> Option<&'a grid::Grid> {

    solver::advance_solving(grid_stack, counters);

    grid_stack.peek_front()
}

#[wasm_bindgen]
pub fn solve(squares: &[u8]) -> Result<js_sys::Array, JsValue> {

    let sector_dimension = match squares.len() {
        16   => 2,
        81   => 3,
        256  => 4,
        625  => 5,
        1296 => 6,
        2401 => 7,
        4096 => 8,
        _ => return Err("Unsupported number of squares".into())
    };

    let mut grid = match grid::Grid::new(sector_dimension) {
        None => return Err("Failed to create initial grid".into()),
        Some(grid_stack) => grid_stack
    };

    for index in 0 .. squares.len() {

        if squares[index] != 0 {

            grid.set_square_value(index as u16 % grid.dimension,
                                  index as u16 / grid.dimension,
                                  squares[index])
        }
    }

    let mut grid_stack = solver::GridStack::new();

    let mut counters = solver::Counters::default();

    grid_stack.attach_to_front_if_possible(grid, &mut counters);

    while let Some(grid) = step(&mut grid_stack, &mut counters)
    {
        if grid.is_complete() {

            let outer_array = js_sys::Array::new_with_length(grid.dimension.into());

            for y in 0 .. grid.dimension {

                let inner_array = js_sys::Array::new_with_length(grid.dimension.into());

                for x in 0 .. grid.dimension {

                    let value = grid.get_square(x, y).get_value();

                    inner_array.set(x.into(), value.into());
                }

                outer_array.set(y.into(), inner_array.into());
            }

            return Ok(outer_array);
        }
    }

    Err("No solution found".into())
}