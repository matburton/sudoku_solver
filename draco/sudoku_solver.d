#sudoku_grid.g
#sudoku_printer.g
#drinc:util.g

extern removePossibilityAt(*Grid_t pGrid; uint x, y, value) void;

proc removePossibilitiesRelatedTo(*Grid_t pGrid; uint x, y, value) void:
    uint indexX, indexY, startX, startY;
    for indexX from 0 upto pGrid*.g_dimension - 1 do
        if indexX ~= x then
            removePossibilityAt(pGrid, indexX, y, value);
        fi;
    od;
    for indexY from 0 upto pGrid*.g_dimension - 1 do
        if indexY ~= y then
            removePossibilityAt(pGrid, x, indexY, value);
        fi;
    od;
    startX := (x / pGrid*.g_sectorDimension) * pGrid*.g_sectorDimension;
    startY := (y / pGrid*.g_sectorDimension) * pGrid*.g_sectorDimension;
    for indexY from startY upto startY + pGrid*.g_sectorDimension - 1 do
        for indexX from startX upto startX + pGrid*.g_sectorDimension - 1 do
            if indexX ~= x and indexY ~= y then
                removePossibilityAt(pGrid, indexX, indexY, value);
            fi;
        od;
    od;
corp;

proc removePossibilityAt(*Grid_t pGrid; uint x, y, value) void:
    bool hadPossibility;
    uint certainValue;
    hadPossibility := squareHasPossibility(pGrid, x, y, value);
    removeSquarePossibility(pGrid, x, y, value);
    if hadPossibility then
        write("-", value, "@", x, ",", y, ";");
        certainValue := getSquareValue(pGrid, x, y);
        if certainValue ~= 0 then
            removePossibilitiesRelatedTo(pGrid, x, y, certainValue);
        fi;
    fi;
corp;

proc setValueAt(*Grid_t pGrid; uint x, y, value) void:
    write("+", value, "@", x, ",", y, ";");
    setSquareValue(pGrid, x, y, value);
    removePossibilitiesRelatedTo(pGrid, x, y, value);
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

proc isPossible(*Grid_t pGrid) bool:
    uint indexX, indexY;
    for indexY from 0 upto pGrid*.g_dimension - 1 do
        for indexX from 0 upto pGrid*.g_dimension - 1 do
            if not isPossibleAt(pGrid, indexX, indexY) then
                return false;
            fi;
        od;
    od;
    true
corp;

proc main() void:
    Grid_t grid;
    *char pGridString;
    MerrorSet(true);
    if setupGrid(&grid, 2) then
        setValueAt(&grid, 0, 0, 1);
        writeln("");
        setValueAt(&grid, 1, 0, 2);
        writeln("");
        setValueAt(&grid, 2, 0, 3);
        pGridString := getGridString(&grid);
        writeln("");
        writeln(pGridString);
        Mfree(pGridString, CharsLen(pGridString) + 1);
        writeln("isPossible: ", pretend(isPossible(&grid), byte));
        freeGrid(&grid);
        writeln("Done");
    fi;
corp;