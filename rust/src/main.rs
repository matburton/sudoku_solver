
mod grid;
mod solver;
mod printer;

fn write_counters(counters: &solver::Counters,
                  grid_stack: &solver::GridStack,
                  _start_time: &std::time::Instant) {

    //println!("Elapsed time: {}",                 start_time.elapsed());
    println!("\r\nGrids in memory:              {}", grid_stack.len());
    println!("Grids created via splitting:  {}", counters.grid_splits);
    println!("Impossible grids encountered: {}", counters.impossible_grids);
    println!("Grids lost due to low memory: {}", counters.grids_lost);
    println!("Solutions found:              {}", counters.solutions);
}

fn main() {

    let mut grid_stack = match solver::GridStack::new(5) {
        None => {

            std::println!("Failed to create initial grid");

            return;
        },
        Some(grid_stack) => grid_stack
    };

    let mut counters = solver::Counters::default();

    let start_time = std::time::Instant::now();

    let mut last_report_time = start_time;

    let mut last_reported_counters = true;

    while let Some(grid) = step(&mut grid_stack, &mut counters)
    {
        if grid.is_complete() {

            counters.solutions += 1;

            std::println!("\r\nSolution:");

            printer::write_grid_string(grid);

            write_counters(&counters, &grid_stack, &start_time);

            grid_stack.drop_front();
        }
        else if last_report_time.elapsed() >= std::time::Duration::from_secs(5) {

            if last_reported_counters {

                println!("\r\nCurrent grid:");

                printer::write_grid_string(grid);
            }
            else {
                
                write_counters(&counters, &grid_stack, &start_time);
            }

            last_report_time = std::time::Instant::now();

            last_reported_counters = !last_reported_counters;
        }
    }
}

fn step<'a>(grid_stack: &'a mut solver::GridStack,
            counters: &mut solver::Counters) -> Option<&'a grid::Grid> {

    if counters.solutions > 0 { return None; }

    solver::advance_solving(grid_stack, counters);

    grid_stack.peek_front()
}