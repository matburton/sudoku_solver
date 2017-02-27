
type Grid_t = struct
{
    uint    g_sectorDimension;
    uint    g_dimension;  
    *Grid_t g_pNext; /* Invasive linked list */
};

/* Returns nil if the grid couldn't be created for any reason */
extern createGrid(uint sectorDimension) *Grid_t;

/* Returns nil if the grid couldn't be cloned for any reason */
extern cloneGrid(*Grid_t pGrid) *Grid_t;

/* Source and target are assumed to have the same dimensions */
extern cloneIntoGrid(*Grid_t pSource, pTarget) void;

/* Doesn't free other grids in list */
extern freeGrid(*Grid_t pGrid) void;

extern setSquareValue(*Grid_t pGrid; uint x, y, value) void;

extern squareHasPossibility(*Grid_t pGrid; uint x, y, value) bool;

/* Returns true if the possibility was present before it was removed */
extern removeSquarePossibility(*Grid_t pGrid; uint x, y, value) void;

/* Returns 0 if the square has multiple possibilities or no possibilities */
extern getSquareValue(*Grid_t pGrid; uint x, y) uint;

extern isSquarePossible(*Grid_t pGrid; uint x, y) bool;