#sudoku_grid.g
#sudoku_printer.g
#drinc:util.g

extern removePossibilityAt(*Grid_t pGrid; uint x, y, value) void;

proc removeRelatedPossibilitiesTo(*Grid_t pGrid; uint x, y, value) void:
    uint index;
    for index from 0 upto pGrid*.g_dimension - 1 do
        if index ~= x then
            removePossibilityAt(pGrid, index, y, value);
        fi;
    od;
    for index from 0 upto pGrid*.g_dimension - 1 do
        if index ~= y then
            removePossibilityAt(pGrid, x, index, value);
        fi;
    od;
    /* TODO: Remove in same sector */
corp;

proc removePossibilityAt(*Grid_t pGrid; uint x, y, value) void:
    bool hadPossibility;
    uint certainValue;
    hadPossibility := squareHasPossibility(pGrid, x, y, value);
    removeSquarePossibility(pGrid, x, y, value);
    if hadPossibility then
        certainValue := getSquareValue(pGrid, x, y);
        if certainValue ~= 0 then
            removeRelatedPossibilitiesTo(pGrid, x, y, certainValue);
        fi;
    fi;
corp;

proc getPossibilityCountAt(*Grid_t pGrid; uint x, y) uint:
    uint index, count;
    count := 0;
    for index from 1 upto pGrid*.g_dimension do
        if squareHasPossibility(pGrid, x, y, index) then
            count := count + 1;
        fi;
    od;
    count
corp;

proc isPossibleAt(*Grid_t pGrid; uint x, y) bool:
    uint index;
    for index from 1 upto pGrid*.g_dimension do
        if squareHasPossibility(pGrid, x, y, index) then
            return true;
        fi;
    od;
    false
corp;

proc main() void:
    Grid_t grid;
    *char pStateLine, pGridString;
    MerrorSet(true);
    if setupGrid(&grid, 2) then
        removePossibilityAt(&grid, 1, 2, 2);
        setSquareValue(&grid, 1, 2, 3);
        pStateLine := getStateLine(&grid);
        writeln(pStateLine);
        Mfree(pStateLine, CharsLen(pStateLine) + 1);
        pGridString := getGridString(&grid);
        writeln(pGridString);      
        Mfree(pGridString, CharsLen(pGridString) + 1);
        freeGrid(&grid);
    fi;
corp;