
type Grid_t = struct
{
    uint   g_sectorDimension;
    uint   g_dimension;  
    arbptr g_pImpl;
};

/* Returns false is the grid couldn't be setup for any reason */
extern setupGrid(*Grid_t pGrid; uint sectorDimension) bool;

/* Returns false is the grid couldn't be cloned for any reason */
extern cloneGrid(*Grid_t pSource, pTarget) bool;

extern freeGrid(*Grid_t pGrid) void;

extern setSquareValue(*Grid_t pGrid; uint x, y, value) void;

extern squareHasPossibility(*Grid_t pGrid; uint x, y, value) bool;

/* Returns true if the possibility was present before it was removed */
extern removeSquarePossibility(*Grid_t pGrid; uint x, y, value) void;

/* Returns 0 if the square has multiple possibilities or no possibilities */
extern getSquareValue(*Grid_t pGrid; uint x, y) uint;