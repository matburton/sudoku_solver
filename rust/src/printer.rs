
use super::grid::{ * };

fn write_char(base: char, offset: u8) {

    print!("{}", (base as u8 + offset) as char);
}

fn write_value(grid: &Grid, value: u8) {

    if grid.sector_dimension <= 3 {

        write_char('0', value);
    }
    else {
        
        match value {
        
            0  ..= 10 => write_char('0', value - 1),
            11 ..= 36 => write_char('A', value - 11),
            37 ..= 62 => write_char('a', value - 37),
            63        => print!("$"),
            _         => print!("@")
        }
    }
}

fn write_square(grid: &Grid, square: &Square) {

    match square.get_possibility_count() {
        0 => print!("!"),
        1 => write_value(grid, square.get_value()),
        _ => print!(".")
    }
}

fn write_divider_line(grid: &Grid) {

    for x in 1 ..= grid.dimension {

        if x == grid.dimension {

            println!("-");
        }
        else {

            print!("--");

            if x % grid.sector_dimension == 0 {

                print!("+-");
            }
        }
    }
}

fn write_row(grid: &Grid, y: u16) {

    for x in 1 ..= grid.dimension {

        write_square(grid, grid.get_square(x - 1, y));

        if x != grid.dimension {

            print!(" ");

            if x % grid.sector_dimension == 0 {

                print!("| ");
            }
        }
    }

    println!("");
}

pub fn write_grid_string(grid: &Grid) {

    for y in 1 ..= grid.dimension {

        write_row(grid, y - 1);

        if    y != grid.dimension
           && y % grid.sector_dimension == 0 {

            write_divider_line(grid);
        }
    }
}