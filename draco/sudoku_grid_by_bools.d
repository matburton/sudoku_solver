#drinc:util.g

type Grid_t = struct
{
    uint    g_sectorDimension;
    uint    g_dimension;  
    *bool   g_pSquarePossibilities;
    *Grid_t g_pNext;
};

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
    uint possibilityCount;
    if sectorDimension = 0 or sectorDimension > 6 then
        return nil;
    fi;
    pGrid := new(Grid_t);
    if pGrid = nil then
        return nil;
    fi;
    pGrid*.g_sectorDimension := sectorDimension;
    pGrid*.g_dimension := raiseToPower(sectorDimension, 2);
    possibilityCount := raiseToPower(pGrid*.g_dimension, 3);
    pGrid*.g_pSquarePossibilities := Malloc(possibilityCount);
    if pGrid*.g_pSquarePossibilities = nil then
        free(pGrid);
        return nil;
    fi;
    BlockFill(pGrid*.g_pSquarePossibilities,
              possibilityCount,
              pretend(true, byte));
    pGrid*.g_pNext := nil;              
    pGrid
corp;

proc cloneGrid(*Grid_t pGrid) *Grid_t:
    *Grid_t pClone;
    uint possibilityCount;
    pClone := new(Grid_t);
    if pClone = nil then
        return nil;
    fi;
    pClone*.g_sectorDimension := pGrid*.g_sectorDimension;
    pClone*.g_dimension := pGrid*.g_dimension;
    possibilityCount := raiseToPower(pGrid*.g_dimension, 3);
    pClone*.g_pSquarePossibilities := Malloc(possibilityCount);
    if pClone*.g_pSquarePossibilities = nil then
        free(pClone);
        return nil;
    fi;
    BlockCopy(pClone*.g_pSquarePossibilities,
              pGrid*.g_pSquarePossibilities,
              possibilityCount);
    pClone*.g_pNext := nil;
    pClone
corp;

proc freeGrid(*Grid_t pGrid) void:
    Mfree(pGrid*.g_pSquarePossibilities,
          raiseToPower(pGrid*.g_dimension, 3));
    free(pGrid);
corp;

proc getSquarePointer(*Grid_t pGrid; uint x, y) *bool:
    pGrid*.g_pSquarePossibilities
    + (((y * pGrid*.g_dimension) + x) * pGrid*.g_dimension)
corp;

proc setSquareValue(*Grid_t pGrid; uint x, y, value) void:
    uint index;
    *bool pSquare;
    pSquare := getSquarePointer(pGrid, x, y);
    for index from 1 upto pGrid*.g_dimension do
        (pSquare + index - 1)* := index = value;
    od;
corp;

proc squareHasPossibility(*Grid_t pGrid; uint x, y, value) bool:
    (getSquarePointer(pGrid, x, y) + value - 1)*
corp;

proc removeSquarePossibility(*Grid_t pGrid; uint x, y, value) void:
    (getSquarePointer(pGrid, x, y) + value - 1)* := false;
corp;

/* This doesn't need to be here in that it isn't specific to the
   way we're storing possibilities but it is handy here as it's
   used in multiple source files and we don't want duplicated code
*/
proc getSquareValue(*Grid_t pGrid; uint x, y) uint:
    uint possibility, value;
    value := 0;
    for possibility from 1 upto pGrid*.g_dimension do
        if squareHasPossibility(pGrid, x, y, possibility) then
            if value > 0 then
                return 0;
            else
                value := possibility;
            fi;
        fi;
    od;
    value
corp;