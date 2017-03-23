#sudoku_grid.g
#drinc:util.g

/* TODO: Reduce the size of the grid, avoid overflows */

/* Disassemble and check if there's any optimisations to be had */

type GridCache_t = struct
{
    uint gc_totalSize;
    uint gc_squareSize;
};

type SquareCache_t = struct
{
    uint sc_possibilityCount;
    uint sc_squareValue; /* TODO: Decache this */
};

uint SQUARES_OFFSET = sizeof(Grid_t) + sizeof(GridCache_t);

proc createGrid(uint sectorDimension) *Grid_t:
    *Grid_t pGrid;
    uint dimension, squareSize, totalSize;   
    *GridCache_t pGridCache;
    *SquareCache_t pSquareCache@pGridCache;
    if sizeof(bool) ~= sizeof(byte) then
        error("Grid implementation needs sizeof(bool) = sizeof(byte)");
    fi;
    dimension := sectorDimension * sectorDimension;  
    squareSize := sizeof(SquareCache_t) + dimension;
    if squareSize % 2 = 1 then
        squareSize := squareSize + 1;
    fi;
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
    BlockFill(pGrid + SQUARES_OFFSET,
              totalSize - SQUARES_OFFSET,
              pretend(true, byte));
    for pSquareCache
        from pretend(pGrid + SQUARES_OFFSET, *SquareCache_t)
        by squareSize
        upto pretend(pGrid + totalSize - 1, *SquareCache_t) do
        pSquareCache*.sc_possibilityCount := dimension;
        pSquareCache*.sc_squareValue := 0;
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

proc getSquarePointer(*Grid_t pGrid; uint x, y) *SquareCache_t:
    pretend(pGrid + SQUARES_OFFSET, *SquareCache_t)
    + (y * pGrid*.g_dimension + x)
    * pretend(pGrid + sizeof(Grid_t), *GridCache_t)*.gc_squareSize
corp;

proc setSquareValue(*Grid_t pGrid; uint x, y, value) void:
    *bool pSquare;
    *SquareCache_t pCache@pSquare;
    pCache := getSquarePointer(pGrid, x, y);
    pCache*.sc_possibilityCount := 1;
    pCache*.sc_squareValue := value;
    BlockFill(pCache + sizeof(SquareCache_t),
              pGrid*.g_dimension,
              pretend(false, byte));
    (pSquare + sizeof(SquareCache_t) + value - 1)* := true;
corp;

proc squareHasPossibility(*Grid_t pGrid; uint x, y, value) bool:
    /* Inlined getSquarePointer */
    (pretend(pGrid + SQUARES_OFFSET, *bool)
     + (y * pGrid*.g_dimension + x)
     * pretend(pGrid + sizeof(Grid_t), *GridCache_t)*.gc_squareSize
     + sizeof(SquareCache_t) + value - 1)*
corp;

proc getSquareValueImpl(*Grid_t pGrid; *bool pSquare) uint:
    uint possibility;
    pSquare := pSquare + sizeof(SquareCache_t);
    for possibility from 0 upto pGrid*.g_dimension - 2 do
        if (pSquare + possibility)* then
            return possibility + 1;
        fi;
    od;
    pGrid*.g_dimension
corp;

proc removeSquarePossibility(*Grid_t pGrid; uint x, y, value) void:
    *bool pSquare;
    *SquareCache_t pCache@pSquare;  
    pCache := getSquarePointer(pGrid, x, y);
    (pSquare + sizeof(SquareCache_t) + value - 1)* := false;
    pCache*.sc_possibilityCount := pCache*.sc_possibilityCount - 1;
    if pCache*.sc_possibilityCount = 0 then
        pCache*.sc_squareValue := 0;
    elif pCache*.sc_possibilityCount = 1 then
        pCache*.sc_squareValue := getSquareValueImpl(pGrid, pSquare);
    fi;
corp;

proc getPossibilityCount(*Grid_t pGrid; uint x, y) uint:
    /* Inlined getSquarePointer */
    (pretend(pGrid + SQUARES_OFFSET, *SquareCache_t)
     + (y * pGrid*.g_dimension + x)
     * pretend(pGrid + sizeof(Grid_t), *GridCache_t)*.gc_squareSize)*.sc_possibilityCount
corp;

proc getSquareValue(*Grid_t pGrid; uint x, y) uint:
    /* Inlined getSquarePointer */
    (pretend(pGrid + SQUARES_OFFSET, *SquareCache_t)
     + (y * pGrid*.g_dimension + x)
     * pretend(pGrid + sizeof(Grid_t), *GridCache_t)*.gc_squareSize)*.sc_squareValue
corp;

proc isPossible(*Grid_t pGrid) bool:
    *uint pCachePossibilityCount;
    *GridCache_t pGridCache;
    pGridCache := pretend(pGrid + sizeof(Grid_t), *GridCache_t);
    for pCachePossibilityCount
        from pretend(pGrid + SQUARES_OFFSET, *uint)
        by pGridCache*.gc_squareSize
        upto pretend(pGrid + pGridCache*.gc_totalSize - 1, *uint) do
        if pCachePossibilityCount* = 0 then
            return false;
        fi;
    od;
    true
corp;

proc isComplete(*Grid_t pGrid) bool:
    *uint pCachePossibilityCount;
    *GridCache_t pGridCache;
    pGridCache := pretend(pGrid + sizeof(Grid_t), *GridCache_t);
    for pCachePossibilityCount
        from pretend(pGrid + pGridCache*.gc_totalSize - pGridCache*.gc_squareSize, *uint)
        by pGridCache*.gc_squareSize
        downto pretend(pGrid + SQUARES_OFFSET, *uint) do
        if pCachePossibilityCount* ~= 1 then
            return false;
        fi;
    od;
    true
corp;