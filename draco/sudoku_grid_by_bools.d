#sudoku_grid.g
#drinc:util.g

/* TODO: Reduce the size of the grid, avoid overflows */

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

proc getSquarePointer(*Grid_t pGrid; uint x, y) *SquareCache_t:
    pretend(pGrid + SQUARES_OFFSET, *SquareCache_t)
    + (y * pGrid*.g_dimension + x)
    * pretend(pGrid + sizeof(Grid_t), *GridCache_t)*.gc_squareSize
corp;

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
    uint totalSize;
    totalSize := pretend(pGrid + sizeof(Grid_t), *GridCache_t)*
                .gc_totalSize;
    pClone := Malloc(totalSize);
    if pClone = nil then
        return nil;
    fi;
    BlockCopy(pClone, pGrid, totalSize);
    gridsInMemory := gridsInMemory + 1;
    pClone
corp;

proc cloneIntoGrid(*Grid_t pSource, pTarget) void:
    BlockCopy(pTarget,
              pSource,
              pretend(pSource + sizeof(Grid_t), *GridCache_t)*.gc_totalSize);
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

proc squareHasPossibility(*Grid_t pGrid; uint x, y, value) bool:
    /* Inlined getSquarePointer */
    (pretend(pGrid + SQUARES_OFFSET, *uint)
     + (y * pGrid*.g_dimension + x)
     * pretend(pGrid + sizeof(Grid_t), *GridCache_t)*.gc_squareSize
     + sizeof(SquareCache_t)
     + ((value - 1) / BITS_PER_PACK) * sizeof(uint))*
    & (pretend(1, uint) << ((value - 1) % BITS_PER_PACK)) ~= 0
corp;

proc getSquareValueImpl(*Grid_t pGrid; uint x, y) uint:
    uint possibility;
    for possibility from 0 upto pGrid*.g_dimension - 2 do
        if squareHasPossibility(pGrid, x, y, possibility + 1) then
            return possibility + 1;
        fi;
    od;
    pGrid*.g_dimension
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

proc getPossibilityCount(*Grid_t pGrid; uint x, y) uint:
    getSquarePointer(pGrid, x, y)*.sc_possibilityCount
corp;

proc getSquareValue(*Grid_t pGrid; uint x, y) uint:
    getSquarePointer(pGrid, x, y)*.sc_squareValue
corp;

proc isPossible(*Grid_t pGrid) bool:
    pretend(pGrid + sizeof(Grid_t), *GridCache_t)*.gc_impossibleSquares = 0
corp;

proc isComplete(*Grid_t pGrid) bool:
    pretend(pGrid + sizeof(Grid_t), *GridCache_t)*.gc_incompleteSquares = 0
corp;