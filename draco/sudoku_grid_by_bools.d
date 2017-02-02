#sudoku_grid.g
#drinc:util.g

proc raiseToPower(uint base; uint exponent) uint:
    uint total, index;   
    total := 1;
    for index from 1 upto exponent do
        total := total * base;
    od;
    total
corp;

proc setupGrid(Grid_t grid; uint sectorDimension) bool:
    bool result;
    uint byteCount;
    if sectorDimension = 0 or sectorDimension > 6 then
        return false;
    fi;
    grid.g_sectorDimension := sectorDimension;
    grid.g_dimension := raiseToPower(sectorDimension, 2);
    byteCount := raiseToPower(grid.g_dimension, 3);
    grid.g_pSquarePossibilities := Malloc(byteCount);
    if grid.g_pSquarePossibilities = nil then
        return false;
    fi;
    BlockFill(grid.g_pSquarePossibilities, byteCount, 1);
    true
corp;

proc cloneGrid(Grid_t source, target) bool:
    uint byteCount;
    BlockCopy(&target, &source, sizeof(Grid_t));
    byteCount := raiseToPower(source.g_dimension, 3);
    target.g_pSquarePossibilities := Malloc(byteCount);
    if target.g_pSquarePossibilities = nil then
        return false;
    fi;
    BlockCopy(target.g_pSquarePossibilities,
              source.g_pSquarePossibilities,
              byteCount);
    true
corp;

proc freeGrid(Grid_t grid) void:
    Mfree(grid.g_pSquarePossibilities, raiseToPower(grid.g_dimension, 3));
corp;

proc getSquarePointer(Grid_t grid; uint x, y) *byte:
    grid.g_pSquarePossibilities
    + (((y * grid.g_dimension) + x) * grid.g_dimension)
corp;

proc setSquareValue(Grid_t grid; uint x, y, value) void:
    uint index;
    *byte pSquare;
    pSquare := getSquarePointer(grid, x, y);
    for index from 1 upto grid.g_dimension do
        (pSquare + index - 1)* := pretend(index = value, byte);
    od;
corp;

proc getSquareValue(Grid_t grid; uint x, y) uint:
    uint index, value;
    *byte pSquare;
    value := 0;
    pSquare := getSquarePointer(grid, x, y);
    for index from 1 upto grid.g_dimension do
        if (pSquare + index - 1)* > 0 then
            if value > 0 then
                return 0;
            else
                value := index;
            fi;
        fi;
    od;
    value
corp;