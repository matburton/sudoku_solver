#drinc:util.g

type Grid_t = struct
{
    uint  g_sectorDimension;
    uint  g_dimension;  
    uint  g_numberOfSquares;
    uint  g_bytesPerSquare;
    *byte g_squarePossibilities;
};

proc raiseToPower(uint base; uint exponent) uint:
    uint total, index;   
    total := 1;
    for index from 1 upto exponent do
        total := total * base;
    od;
    total
corp;

proc divideToCeiling(uint numerator; uint denominator) uint:
    uint result;
    result := numerator / denominator;
    if numerator % denominator ~= 0 then
        result := result + 1
    fi;
    result
corp;

proc resetSquarePossibilities(Grid_t grid) void:
    uint index;
    byte highByte;
    highByte := grid.g_dimension % 8;
    for index from 0 upto grid.g_numberOfSquares * grid.g_bytesPerSquare do
        if index % grid.g_bytesPerSquare = 0 then
            (grid.g_squarePossibilities + index)* := highByte;
        else
            (grid.g_squarePossibilities + index)* := 0xff;
        fi;
    od;
corp;

proc setupGrid(Grid_t grid; uint sectorDimension) bool:
    bool result;
    if sectorDimension = 0 then
        result := false;
    else
        grid.g_sectorDimension := sectorDimension;
        grid.g_dimension       := raiseToPower(sectorDimension, 2);
        grid.g_numberOfSquares := raiseToPower(grid.g_dimension, 2);
        grid.g_bytesPerSquare  := divideToCeiling(grid.g_dimension, 8);
        
        grid.g_squarePossibilities := Malloc
            (grid.g_bytesPerSquare * grid.g_numberOfSquares);

        result := grid.g_squarePossibilities ~= nil;
        
        if result then
            resetSquarePossibilities(grid);
        fi;
    fi;
    result
corp;

proc freeGrid(Grid_t grid) void:
    Mfree(grid.g_squarePossibilities,
          grid.g_bytesPerSquare * grid.g_numberOfSquares);
corp;

proc main() void:
    Grid_t grid;
    MerrorSet(true);
    if setupGrid(grid, 3) then
        writeln("Created a grid with ", grid.g_numberOfSquares, " squares");
        freeGrid(grid); 
    fi;
corp;