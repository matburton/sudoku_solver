
type Grid_t = struct
{
    uint  g_sectorDimension;
    uint  g_dimension;  
    *byte g_pSquarePossibilities;
};

/* Returns false is the grid couldn't be setup for any reason
*/
extern setupGrid(Grid_t grid; uint sectorDimension) bool;

/* Returns false is the grid couldn't be cloned for any reason
*/
extern cloneGrid(Grid_t source, target) bool;

extern freeGrid(Grid_t grid) void;

extern setSquareValue(Grid_t grid; uint x, y, value) void;

/* Returns 0 if the square has multiple possibilities or no possibilities
*/
extern getSquareValue(Grid_t grid; uint x, y) uint;