
#include "../include/sudoku_solver.h"

void removePossibilityAt(struct Grid pGrid, uint16_t x, uint16_t y, uint8_t value);

void removePossibilitiesRelatedTo(struct Grid* pGrid, uint16_t x, uint16_t y, uint8_t value)
{
    // TODO
}

void removePossibilityAt(struct Grid* pGrid, uint16_t x, uint16_t y, uint8_t value)
{
    if (!squareHasPossibility(pGrid, x, y, value)) return;

    removeSquarePossibility(pGrid, x, y, value);

    value = getSquareValue(pGrid, x, y);

    if (value != 0)
    {
        removePossibilitiesRelatedTo(pGrid, x, y, value);
    }
}

void setValueAt(struct Grid* pGrid, uint16_t x, uint16_t y, uint8_t value)
{
    setSquareValue(pGrid, x, y, value);

    removePossibilitiesRelatedTo(pGrid, x, y, value);
}

// Returns zero if no value could be deduced
//
uint8_t getDeducedValueAt(struct Grid* pGrid, uint16_t x, uint16_t y)
{
    // TODO
}

void refineGrid(struct Grid* pGrid)
{
    // TODO
}

struct Grid* detachFrontGrid(struct Grid* pGridList)
{
    if (pGridList->pNext == pGridList) return NULL;

    pGridList->pNext->pPrevious = pGridList->pPrevious;
    pGridList->pPrevious->pNext = pGridList->pNext;

    return pGridList->pNext;
}

struct Grid* freeFrontGrid(struct Grid* pGridList)
{
    struct Grid* pGrid = pGridList;

    pGridList = detachFrontGrid(pGridList);

    freeGrid(pGrid);

    return pGridList;
}

void freeGridList(struct Grid* pGridList)
{
    while (pGridList != NULL)
    {
        pGridList = freeFrontGrid(pGridList);
    }
}

struct Grid* attachToFrontIfPossible(struct Grid* pGridList,
                                     struct Grid* pGrid,
                                     struct Counters* pCounters)
{
    if (!isPossible(pGrid))
    {
        pCounters->impossibleGrids += 1;

        freeGrid(pGrid);

        return pGridList;
    }

    if (NULL == pGridList)
    {
        pGrid->pNext     = pGrid;
        pGrid->pPrevious = pGrid;
    }
    else
    {
        pGrid->pNext     = pGridList;
        pGrid->pPrevious = pGridList->pPrevious;

        pGridList->pPrevious->pNext = pGrid;
        pGridList->pPrevious        = pGrid;
    }

    return pGrid;
}

uint8_t getAPossibilityAt(struct Grid* pGrid, uint16_t x, uint16_t y)
{
    for (uint16_t index = 1; index <= pGrid->dimension; ++index)
    {
        if (squareHasPossibility(pGrid, x, y, index))
        {
            return index;
        }
    }

    return 0;
}

// must not be called with complete or impossible grids
//
struct Grid* splitFirstGridToFront(struct Grid* pGridList,
                                   struct Counters* pCounters)
{
    // TODO
}

struct Grid* advanceSolving(struct Grid* pGridList, struct Counters* pCounters)
{
    // TODO
}