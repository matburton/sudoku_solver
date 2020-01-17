
#include <stdint.h>

#include "sudoku_grid.h"
#include <windows.h>

struct Counters
{
    ULONGLONG startTime;
    unsigned int gridSplits;
    unsigned int impossibleGrids;
    unsigned int gridsLost;
    unsigned int solutions;
};

void setValueAt(struct Grid* pGrid, uint16_t x, uint16_t y, uint8_t value);

struct Grid* freeFrontGrid(struct Grid* pGridList);

void freeGridList(struct Grid* pGridList);

// Returns nil if there are no more solutions
// Caller must free front grid if complete before re-calling
//
struct Grid* advanceSolving(struct Grid* pGridList, struct Counters* pCounters);