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
    uint sc_possibilityCount;
};

uint SQUARES_OFFSET = sizeof(Grid_t) + sizeof(GridCache_t);

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
    pGridCache*.gc_impossibleSquares := 0;
    pGridCache*.gc_incompleteSquares := dimension * dimension;    
    BlockFill(pGrid + SQUARES_OFFSET,
              totalSize - SQUARES_OFFSET,
              pretend(true, byte));
    for y from 0 upto dimension - 1 do
        for x from 0 upto dimension - 1 do          
            getSquarePointer(pGrid, x, y)*.sc_possibilityCount := dimension;
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
    *bool pSquare;
    *SquareCache_t pSquareCache@pSquare;
    *GridCache_t pGridCache;
    pSquareCache := getSquarePointer(pGrid, x, y);
    pGridCache := pretend(pGrid + sizeof(Grid_t), *GridCache_t);
    if pSquareCache*.sc_possibilityCount = 0 then
        pGridCache*.gc_impossibleSquares := pGridCache*.gc_impossibleSquares - 1;
    elif pSquareCache*.sc_possibilityCount > 1 then
        pGridCache*.gc_incompleteSquares := pGridCache*.gc_incompleteSquares - 1;
    fi;
    pSquareCache*.sc_possibilityCount := 1;   
    BlockFill(pSquareCache + sizeof(SquareCache_t),
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

proc removeSquarePossibility(*Grid_t pGrid; uint x, y, value) boid:
    *bool pSquare;
    *SquareCache_t pSquareCache@pSquare;  
    *GridCache_t pGridCache;
    pSquareCache := getSquarePointer(pGrid, x, y);
    if not (pSquare + sizeof(SquareCache_t) + value - 1)* then
        return false;
    fi;
    (pSquare + sizeof(SquareCache_t) + value - 1)* := false;
    pSquareCache*.sc_possibilityCount := pSquareCache*.sc_possibilityCount - 1;
    pGridCache := pretend(pGrid + sizeof(Grid_t), *GridCache_t);
    if pSquareCache*.sc_possibilityCount = 0 then
        pGridCache*.gc_impossibleSquares := pGridCache*.gc_impossibleSquares + 1;
        pGridCache*.gc_incompleteSquares := pGridCache*.gc_incompleteSquares + 1;
    elif pSquareCache*.sc_possibilityCount = 1 then
        pGridCache*.gc_incompleteSquares := pGridCache*.gc_incompleteSquares - 1;
    fi;
    true
corp;

proc getPossibilityCount(*Grid_t pGrid; uint x, y) uint:
    getSquarePointer(pGrid, x, y)*.sc_possibilityCount
corp;

proc getSquareValue(*Grid_t pGrid; uint x, y) uint:
    *bool pSquare;
    *SquareCache_t pSquareCache@pSquare;  
    uint possibility;
    pSquareCache := getSquarePointer(pGrid, x, y);
    if pSquareCache*.sc_possibilityCount ~= 1 then
        return 0;
    fi;
    pSquare := pSquare + sizeof(SquareCache_t);
    for possibility from 0 upto pGrid*.g_dimension - 2 do
        if (pSquare + possibility)* then
            return possibility + 1;
        fi;
    od;
    pGrid*.g_dimension
corp;

proc isPossible(*Grid_t pGrid) bool:
    pretend(pGrid + sizeof(Grid_t), *GridCache_t)*.gc_impossibleSquares = 0
corp;

proc isComplete(*Grid_t pGrid) bool:
    pretend(pGrid + sizeof(Grid_t), *GridCache_t)*.gc_incompleteSquares = 0
corp;