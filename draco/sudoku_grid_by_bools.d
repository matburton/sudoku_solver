#sudoku_grid.g
#drinc:util.g

uint POSSIBILITY_OFFSET = sizeof(Grid_t);

proc raiseToPower(uint base; uint exponent) uint:
    uint total, index;   
    total := 1;
    for index from 1 upto exponent do
        total := total * base;
    od;
    total
corp;

proc createGrid(uint sectorDimension) *Grid_t:
    *Grid_t pGrid;
    uint dimension, possibilityCount;
    if sizeof(bool) ~= sizeof(byte) then
        error("Grid implementation needs sizeof(bool) = sizeof(byte)");
    fi;
    if sectorDimension = 0 or sectorDimension > 6 then
        return nil;
    fi;
    dimension := raiseToPower(sectorDimension, 2);
    possibilityCount := raiseToPower(dimension, 3);
    pGrid := pretend(Malloc(sizeof(Grid_t) + possibilityCount), *Grid_t);
    if pGrid = nil then
        return nil;
    fi;
    pGrid*.g_sectorDimension := sectorDimension;
    pGrid*.g_dimension := dimension;
    pGrid*.g_pNext := pGrid;
    pGrid*.g_pPrevious := pGrid;
    BlockFill(pGrid + POSSIBILITY_OFFSET,
              possibilityCount,
              pretend(true, byte));
    gridsInMemory := gridsInMemory + 1;
    pGrid
corp;

proc cloneGrid(*Grid_t pGrid) *Grid_t:
    *Grid_t pClone;
    uint possibilityCount;
    possibilityCount := raiseToPower(pGrid*.g_dimension, 3);
    pClone := pretend(Malloc(sizeof(Grid_t) + possibilityCount), *Grid_t);
    if pClone = nil then
        return nil;
    fi;
    BlockCopy(pClone, pGrid, sizeof(Grid_t) + possibilityCount);
    gridsInMemory := gridsInMemory + 1;
    pClone
corp;

proc cloneIntoGrid(*Grid_t pSource, pTarget) void:
    BlockCopy(pTarget,
              pSource,
              sizeof(Grid_t) + raiseToPower(pSource*.g_dimension, 3));
corp;

proc freeGrid(*Grid_t pGrid) void:
    Mfree(pGrid, sizeof(Grid_t) + raiseToPower(pGrid*.g_dimension, 3));
    gridsInMemory := gridsInMemory - 1;
corp;

proc getSquarePointer(*Grid_t pGrid; uint x, y) *bool:
    pretend(pGrid, *bool)
    + POSSIBILITY_OFFSET
    + (((y * pGrid*.g_dimension) + x) * pGrid*.g_dimension)
corp;

proc setSquareValue(*Grid_t pGrid; uint x, y, value) void:
    *bool pSquare;
    pSquare := getSquarePointer(pGrid, x, y);
    BlockFill(pSquare, pGrid*.g_dimension, pretend(false, byte));
    (pSquare + value - 1)* := true;
corp;

proc squareHasPossibility(*Grid_t pGrid; uint x, y, value) bool:
    /* Inlined getSquarePointer */
    (pretend(pGrid, *bool)
     + POSSIBILITY_OFFSET
     + (((y * pGrid*.g_dimension) + x) * pGrid*.g_dimension)
     + value - 1)*
corp;

proc removeSquarePossibility(*Grid_t pGrid; uint x, y, value) void:
    (getSquarePointer(pGrid, x, y) + value - 1)* := false;
corp;

proc getPossibilityCount(*Grid_t pGrid; uint x, y) uint:
    uint possibility, count;
    *bool pSquare;
    count := 0;
    pSquare := getSquarePointer(pGrid, x, y);
    for possibility from 0 upto pGrid*.g_dimension - 1 do
        if (pSquare + possibility)* then
            count := count + 1;
        fi;
    od;
    count
corp;

proc getSquareValue(*Grid_t pGrid; uint x, y) uint:
    uint possibility, value;
    *bool pSquare;
    value := 0;
    pSquare := getSquarePointer(pGrid, x, y);
    for possibility from 0 upto pGrid*.g_dimension - 1 do
        if (pSquare + possibility)* then
            if value > 0 then
                return 0;
            else
                value := possibility + 1;
            fi;
        fi;
    od;
    value
corp;

proc isSquarePossible(*Grid_t pGrid; uint x, y) bool:
    uint possibility;
    *bool pSquare;
    pSquare := getSquarePointer(pGrid, x, y);
    for possibility from 0 upto pGrid*.g_dimension - 1 do
        if (pSquare + possibility)* then
            return true;
        fi;
    od;
    false
corp;