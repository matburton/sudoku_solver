#sudoku_grid.g
#drinc:util.g

/* TODO: Avoid overflows */

/* Disassemble and check if there's any optimisations to be had */

type GridCache_t = struct
{
    uint gc_totalSize;
    uint gc_squareSize;
    uint gc_impossibleSquares;
    uint gc_incompleteSquares;
};

type SquareCache_t = struct
{
    ushort sc_possibilityCount;
    ushort sc_squareValue;
};

uint SQUARES_OFFSET = sizeof(Grid_t) + sizeof(GridCache_t);

uint BITS_PER_PACK = sizeof(uint) * 8;

extern getSquarePointer(*Grid_t pGrid; uint x, y) *SquareCache_t;

proc createGrid(uint sectorDimension) *Grid_t:
    uint dimension, squareSize, totalSize, x, y;
    *Grid_t pGrid;
    *GridCache_t pGridCache;
    *SquareCache_t pSquareCache;
    if sectorDimension > 5 then /* We currently overflow pointers */
        return nil;             /* with sector size 6 or greater */
    fi;                         /* and bigger types slows it down */
    dimension := sectorDimension * sectorDimension;  
    squareSize := sizeof(SquareCache_t)
                + (((dimension - 1) / BITS_PER_PACK) + 1) * sizeof(uint);
    totalSize := sizeof(Grid_t) + sizeof(GridCache_t)
               + dimension * dimension * squareSize;
    pGrid := pretend(Malloc(totalSize), *Grid_t);
    if pGrid = nil then
        return nil;
    fi;
    pGrid*.g_sectorDimension := sectorDimension;
    pGrid*.g_dimension := dimension;
    pGrid*.g_pNext := pGrid;
    pGrid*.g_pPrevious := pGrid;
    pGridCache := pretend(pGrid + sizeof(Grid_t), *GridCache_t);
    pGridCache*.gc_totalSize := totalSize;
    pGridCache*.gc_squareSize := squareSize;
    pGridCache*.gc_impossibleSquares := 0;
    pGridCache*.gc_incompleteSquares := dimension * dimension;
    BlockFill(pGrid + SQUARES_OFFSET,
              totalSize - SQUARES_OFFSET,
              0xff);
    for y from 0 upto dimension - 1 do
        for x from 0 upto dimension - 1 do
            pSquareCache := getSquarePointer(pGrid, x, y);
            pSquareCache*.sc_possibilityCount := dimension;
            pSquareCache*.sc_squareValue := 0;
        od;
    od;
    gridsInMemory := gridsInMemory + 1;  
    pGrid
corp;

proc cloneGrid(*Grid_t pGrid) *Grid_t:
    arbptr pClone;
    pClone := Malloc(pretend(pGrid + sizeof(Grid_t), *GridCache_t)*.gc_totalSize);
    if pClone = nil then
        return nil;
    fi;
    cloneIntoGrid(pGrid, pClone);
    gridsInMemory := gridsInMemory + 1;
    pClone
corp;

proc freeGrid(*Grid_t pGrid) void:
    Mfree(pGrid, pretend(pGrid + sizeof(Grid_t), *GridCache_t)*.gc_totalSize);
    gridsInMemory := gridsInMemory - 1;
corp;

proc setSquareValue(*Grid_t pGrid; uint x, y, value) void:
    *uint pSquare;
    *SquareCache_t pSquareCache@pSquare;
    *GridCache_t pGridCache;
    pSquareCache := getSquarePointer(pGrid, x, y);
    pGridCache := pretend(pGrid + sizeof(Grid_t), *GridCache_t);
    if pSquareCache*.sc_possibilityCount = 0 then
        pGridCache*.gc_impossibleSquares := pGridCache*.gc_impossibleSquares - 1;
    fi;
    if pSquareCache*.sc_possibilityCount ~= 1 then
        pGridCache*.gc_incompleteSquares := pGridCache*.gc_incompleteSquares - 1;
    fi;
    pSquareCache*.sc_possibilityCount := 1;
    pSquareCache*.sc_squareValue := value;
    BlockFill(pSquareCache + sizeof(SquareCache_t),
              pGridCache*.gc_squareSize - sizeof(SquareCache_t),
              0x0);
    pSquare := pSquare + sizeof(SquareCache_t)
             + ((value - 1) / BITS_PER_PACK) * sizeof(uint);
    pSquare* := pSquare* | (pretend(1, uint) << ((value - 1) % BITS_PER_PACK));
corp;

proc getSquareValueImpl(*Grid_t pGrid; uint x, y) uint:
    uint possibility;
    for possibility from 1 upto pGrid*.g_dimension - 1 do
        if squareHasPossibility(pGrid, x, y, possibility) then
            return possibility;
        fi;
    od;
    possibility
corp;

proc removeSquarePossibility(*Grid_t pGrid; uint x, y, value) void:
    *uint pSquare;
    uint squareValue;
    uint mask;
    *SquareCache_t pSquareCache;
    *GridCache_t pGridCache;  
    pSquareCache := getSquarePointer(pGrid, x, y);
    pSquare := pretend(pSquareCache, *uint) + sizeof(SquareCache_t)
             + ((value - 1) / BITS_PER_PACK) * sizeof(uint);
    mask := pretend(1, uint) << ((value - 1) % BITS_PER_PACK);
    squareValue := pSquare*;
    if squareValue | mask = 0 then
        return;
    fi;
    pSquare* := squareValue & ~mask;
    pSquareCache*.sc_possibilityCount := pSquareCache*.sc_possibilityCount - 1;
    pGridCache := pretend(pGrid + sizeof(Grid_t), *GridCache_t);
    if pSquareCache*.sc_possibilityCount = 0 then
        pSquareCache*.sc_squareValue := 0;
        pGridCache*.gc_impossibleSquares := pGridCache*.gc_impossibleSquares + 1;
        pGridCache*.gc_incompleteSquares := pGridCache*.gc_incompleteSquares + 1;
    elif pSquareCache*.sc_possibilityCount = 1 then
        pSquareCache*.sc_squareValue := getSquareValueImpl(pGrid, x, y);
        pGridCache*.gc_incompleteSquares := pGridCache*.gc_incompleteSquares - 1;
    fi;
corp;

proc mustBeValueByRow(*Grid_t pGrid; uint x, y, value) bool:
    uint squareSize, mask, index;
    *uint pSquare;
    squareSize := pretend(pGrid + sizeof(Grid_t), *GridCache_t)*.gc_squareSize;    
    pSquare := pretend(pGrid + SQUARES_OFFSET, *uint)
             + y * pGrid*.g_dimension * squareSize
             + sizeof(SquareCache_t)
             + ((value - 1) / BITS_PER_PACK) * sizeof(uint);
    mask := pretend(1, uint) << ((value - 1) % BITS_PER_PACK);
    for index from 0 upto pGrid*.g_dimension - 1 do
        if index ~= x and pSquare* & mask ~= 0 then
            return false;
        fi;
        pSquare := pSquare + squareSize;
    od;
    true
corp;

proc mustBeValueByColumn(*Grid_t pGrid; uint x, y, value) bool:
    uint bumpSize, mask, index;
    *uint pSquare;
    bumpSize := pretend(pGrid + sizeof(Grid_t), *GridCache_t)*.gc_squareSize;    
    pSquare := pretend(pGrid + SQUARES_OFFSET, *uint)
             + x * bumpSize + sizeof(SquareCache_t)
             + ((value - 1) / BITS_PER_PACK) * sizeof(uint);
    mask := pretend(1, uint) << ((value - 1) % BITS_PER_PACK);
    bumpSize := bumpSize * pGrid*.g_dimension;
    for index from 0 upto pGrid*.g_dimension - 1 do
        if index ~= y and pSquare* & mask ~= 0 then
            return false;
        fi;
        pSquare := pSquare + bumpSize;
    od;
    true
corp;

proc mustBeValueBySector(*Grid_t pGrid; uint x, y, value) bool:
    uint squareSize, dimension, sectorDimension, bumpSize, mask, index, ignoreIndex;
    *uint pSquare;
    squareSize := pretend(pGrid + sizeof(Grid_t), *GridCache_t)*.gc_squareSize;
    dimension := pGrid*.g_dimension;
    sectorDimension := pGrid*.g_sectorDimension;
    pSquare := pretend(pGrid + SQUARES_OFFSET, *uint)
             + (((y / sectorDimension) * sectorDimension) * pGrid*.g_dimension
             + ((x / sectorDimension) * sectorDimension)) * squareSize
             + sizeof(SquareCache_t)
             + ((value - 1) / BITS_PER_PACK) * sizeof(uint);
    mask := pretend(1, uint) << ((value - 1) % BITS_PER_PACK);
    bumpSize := squareSize * (dimension - sectorDimension + 1);
    ignoreIndex := ((y % sectorDimension) * sectorDimension) + (x % sectorDimension);
    for index from 0 upto pGrid*.g_dimension - 1 do
        if index ~= ignoreIndex and pSquare* & mask ~= 0 then
            return false;
        fi;
        if (index + 1) % sectorDimension ~= 0 then
            pSquare := pSquare + squareSize;
        else
            pSquare := pSquare + bumpSize;
        fi;
    od;
    true
corp;