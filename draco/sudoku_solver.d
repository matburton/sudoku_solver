#sudoku_grid.g
#drinc:util.g

proc main() void:
    Grid_t grid, gridB, gridC;
    MerrorSet(true);
    if setupGrid(grid, 3) then
        writeln("Value at 1,2 is ", getSquareValue(grid, 1, 2));
        ignore(cloneGrid(grid, gridB));
        setSquareValue(grid, 1, 2, 3);
        writeln("Value at 1,2 is ", getSquareValue(grid, 1, 2));
        ignore(cloneGrid(grid, gridC));
        freeGrid(grid); 
        writeln("Value at 1,2 in cloneB is ", getSquareValue(gridB, 1, 2));
        writeln("Value at 1,2 in cloneC is ", getSquareValue(gridC, 1, 2));
        freeGrid(gridB);
        freeGrid(gridC);
    fi;
corp;