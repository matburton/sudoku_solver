#drinc:util.g

type Grid_t = struct
{
    uint  g_sectorDimension;
    uint  g_dimension;  
    *bool g_pSquarePossibilities;
};

proc raiseToPower(uint base; uint exponent) uint:
    uint total, index;   
    total := 1;
    for index from 1 upto exponent do
        total := total * base;
    od;
    total
corp;

proc setupGrid(*Grid_t pGrid; uint sectorDimension) bool:
    bool result;
    uint byteCount;
    if sectorDimension = 0 or sectorDimension > 6 then
        return false;
    fi;
    pGrid*.g_sectorDimension := sectorDimension;
    pGrid*.g_dimension := raiseToPower(sectorDimension, 2);
    byteCount := raiseToPower(pGrid*.g_dimension, 3);
    pGrid*.g_pSquarePossibilities := Malloc(byteCount);
    if pGrid*.g_pSquarePossibilities = nil then
        return false;
    fi;
    BlockFill(pGrid*.g_pSquarePossibilities,
              byteCount,
              pretend(true, byte));
    true
corp;

proc cloneGrid(*Grid_t pSource, pTarget) bool:
    uint byteCount;
    pTarget*.g_sectorDimension := pSource*.g_sectorDimension;
    pTarget*.g_dimension := pSource*.g_dimension;
    byteCount := raiseToPower(pSource*.g_dimension, 3);
    pTarget*.g_pSquarePossibilities := Malloc(byteCount);
    if pTarget*.g_pSquarePossibilities = nil then
        return false;
    fi;
    BlockCopy(pTarget*.g_pSquarePossibilities,
              pSource*.g_pSquarePossibilities,
              byteCount);
    true
corp;

proc freeGrid(*Grid_t pGrid) void:
    Mfree(pGrid*.g_pSquarePossibilities,
          raiseToPower(pGrid*.g_dimension, 3));
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

proc getSquareValue(*Grid_t pGrid; uint x, y) uint:
    uint index, value;
    value := 0;
    for index from 1 upto pGrid*.g_dimension do
        if squareHasPossibility(pGrid, x, y, index) then
            if value > 0 then
                return 0;
            else
                value := index;
            fi;
        fi;
    od;
    value
corp;