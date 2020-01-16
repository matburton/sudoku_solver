
#include "../include/sudoku_solver.h"

void removePossibilityAt(struct Grid* pGrid, uint16_t x, uint16_t y, uint8_t value);

void removePossibilitiesRelatedTo(struct Grid* pGrid, uint16_t x, uint16_t y, uint8_t value)
{
    for (uint16_t indexX = 0; indexX < pGrid->dimension; ++indexX)
    {
        if (indexX != x)
        {
            removePossibilityAt(pGrid, indexX, y, value);
        }
    }

    for (uint16_t indexY = 0; indexY < pGrid->dimension; ++indexY)
    {
        if (indexY != y)
        {
            removePossibilityAt(pGrid, x, indexY, value);
        }
    }

    uint16_t sectorDimension = pGrid->sectorDimension;

    uint16_t startX = (x / sectorDimension) * sectorDimension;
    uint16_t startY = (y / sectorDimension) * sectorDimension;

    for (uint16_t indexY = startY; indexY < startY + sectorDimension; ++indexY)
    {
        for (uint16_t indexX = startX; indexX < startX + sectorDimension; ++indexX)
        {
            if (indexX != x && indexY != y)
            {
                removePossibilityAt(pGrid, indexX, indexY, value);
            }
        }
    }
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
    if (getPossibilityCount(pGrid, x, y) > 1)
    {
        for (uint8_t value = 1; value <= pGrid->dimension; ++value)
        {
            if (   squareHasPossibility   (pGrid, x, y, value)
                && (   mustBeValueByRow   (pGrid, x, y, value)
                    || mustBeValueByColumn(pGrid, x, y, value)
                    || mustBeValueBySector(pGrid, x, y, value)))
            {
                return value;
            }
        }
    }

    return 0;
}

void refineGrid(struct Grid* pGrid)
{
    uint16_t x = 0, y = 0, lastX = 0, lastY = 0;
    
    while (true)
    {
        uint8_t value = getDeducedValueAt(pGrid, x, y);

        if (value != 0)
        {
            setValueAt(pGrid, x, y, value);

            if (!isPossible(pGrid)) return;

            lastX = x;
            lastY = y;
        }

        if (x < pGrid->dimension - 1)
        {
            x += 1;
        }
        else
        {
            x = 0;
            y = (y + 1) % pGrid->dimension;
        }
        
        if (x == lastX && y == lastY) return;
    }
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
    while (pGridList)
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

        // HACK
        // {
        uint16_t squares = pGridList->dimension * pGridList->dimension;

        if (pCounters->impossibleGrids % squares == 0 && pGridList)
        {
            pGridList = pGridList->pPrevious;
        }
        // }

        return pGridList;
    }

    if (!pGridList)
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
    for (uint8_t index = 1; index <= pGrid->dimension; ++index)
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
    uint16_t bestCount = 0, bestX = 0, bestY = 0;

    struct Grid* pGrid = pGridList;

    pGridList = detachFrontGrid(pGridList);

    for (uint16_t y = 0; y < pGrid->dimension; ++y)
    {
        for (uint16_t x = 0; x < pGrid->dimension; ++x)
        {
            uint16_t count = getPossibilityCount(pGrid, x, y);

            if (count > 1)
            {
                if (0 == bestCount || count < bestCount)
                {
                    bestCount = count;

                    bestX = x;
                    bestY = y;
                }
            }
        }
    }

    uint8_t possibility = getAPossibilityAt(pGrid, bestX, bestY);

    struct Grid* pCloneGrid = cloneGrid(pGrid);

    if (!pCloneGrid)
    {
        pCounters->gridsLost += 1;

        if (pGridList)
        {
            pCloneGrid = pGridList->pPrevious;

            pGridList = detachFrontGrid(pGridList->pPrevious);

            cloneIntoGrid(pGrid, pCloneGrid);
        }
    }

    if (pCloneGrid)
    {
        pCounters->gridSplits += 1;

        removePossibilityAt(pCloneGrid, bestX, bestY, possibility);

        pGridList = attachToFrontIfPossible(pGridList, pCloneGrid, pCounters);
    }

    setValueAt(pGrid, bestX, bestY, possibility);

    return attachToFrontIfPossible(pGridList, pGrid, pCounters);
}

struct Grid* advanceSolving(struct Grid* pGridList, struct Counters* pCounters)
{
    if (!pGridList) return NULL;

    if (!isPossible(pGridList))
    {
        pCounters->impossibleGrids += 1;

        pGridList = freeFrontGrid(pGridList);

        // HACK
        // {
        uint16_t squares = pGridList->dimension * pGridList->dimension;

        if (pCounters->impossibleGrids % squares == 0 && pGridList)
        {
            pGridList = pGridList->pPrevious;
        }
        // }

        if (!pGridList) return NULL;
    }

    refineGrid(pGridList);

    if (!isComplete(pGridList) && isPossible(pGridList))
    {
        pGridList = splitFirstGridToFront(pGridList, pCounters);
    }

    return pGridList;
}