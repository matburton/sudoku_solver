
#include "../include/sudoku_grid.h"

#include <windows.h>

static inline uint64_t* getSquarePointer(struct Grid* pGrid, uint16_t x, uint16_t y)
{
    return (uint64_t*)(pGrid + 1) + (y * pGrid->dimension + x);
}

static inline uint64_t toMask(uint8_t value)
{
    return (uint64_t)1 << (value - 1);
}

static inline uint64_t countSetBits(uint64_t square)
{
    uint64_t count;

    for (count = 0; square; ++count)
    {
        square &= square - 1;
    }

    return count;
}

static size_t getTotalSize(uint16_t dimension)
{
    return sizeof(struct Grid)
         + sizeof(uint64_t) * dimension * dimension;
}

struct Grid* createGrid(uint16_t sectorDimension)
{
    if (sectorDimension <= 0 || sectorDimension > 8) return NULL;

    uint16_t dimension   = sectorDimension * sectorDimension;
    uint16_t squareCount = dimension * dimension;
    size_t totalSize     = getTotalSize(dimension);

    HANDLE heap = GetProcessHeap();

    if (!heap) return NULL;

    struct Grid* pGrid = HeapAlloc(heap, 0, totalSize);

    if (!pGrid) return NULL;

    pGrid->sectorDimension   = sectorDimension;
    pGrid->dimension         = dimension;
    pGrid->pNext             = pGrid;
    pGrid->pPrevious         = pGrid;
    pGrid->impossibleSquares = 0;
    pGrid->incompleteSquares = squareCount;

    uint64_t square = dimension == 8
                    ? (uint64_t)0 - 1
                    : ((uint64_t)1 << dimension) - 1;

    for (uint64_t* pSquare = getSquarePointer(pGrid, 0, 0);
         pSquare <= getSquarePointer(pGrid, dimension - 1, dimension - 1);
         ++pSquare)
    {
        *pSquare = square;
    }

    gridsInMemory += 1;

    return pGrid;
}

struct Grid* cloneGrid(struct Grid* pGrid)
{
    if (gridsInMemory >= 300000) return NULL; // HACK

    HANDLE heap = GetProcessHeap();

    if (!heap) return NULL;

    struct Grid* pClone = HeapAlloc(heap, 0, getTotalSize(pGrid->dimension));

    if (!pClone) return NULL;

    cloneIntoGrid(pGrid, pClone);

    gridsInMemory += 1;

    return pClone;
}

void cloneIntoGrid(struct Grid* pSource, struct Grid* pTarget)
{
    char* pDest = (char*)pTarget;
    char* pSrc = (char*)pSource;

    for (size_t count = 0; count < getTotalSize(pSource->dimension); ++count)
    {
        *pDest++ = *pSrc++;
    }
}

void freeGrid(struct Grid* pGrid)
{
    HeapFree(GetProcessHeap(), 0, pGrid);

    gridsInMemory -= 1;
}

void setSquareValue(struct Grid* pGrid, uint16_t x, uint16_t y, uint8_t value)
{
    uint64_t* pSquare = getSquarePointer(pGrid, x, y);

    uint64_t possibilityCount = countSetBits(*pSquare);

    if (0 == possibilityCount)
    {
        pGrid->impossibleSquares -= 1;
    }

    if (possibilityCount != 1)
    {
        pGrid->incompleteSquares -= 1;
    }

    *pSquare = (uint64_t)1 << (value - 1);
}

bool squareHasPossibility(struct Grid* pGrid, uint16_t x, uint16_t y, uint8_t value)
{
    return (*getSquarePointer(pGrid, x, y) & toMask(value)) != 0;
}

void removeSquarePossibility(struct Grid* pGrid, uint16_t x, uint16_t y, uint8_t value)
{
    uint64_t* pSquare = getSquarePointer(pGrid, x, y);

    *pSquare = *pSquare & ~toMask(value);

    uint64_t possibilityCount = countSetBits(*pSquare);

    if (0 == possibilityCount)
    {
        pGrid->impossibleSquares += 1;
        pGrid->incompleteSquares += 1;
    }
    else if (1 == possibilityCount)
    {
        pGrid->incompleteSquares -= 1;
    }
}

uint16_t getPossibilityCount(struct Grid* pGrid, uint16_t x, uint16_t y)
{
    return (uint16_t)countSetBits(*getSquarePointer(pGrid, x, y));
}

uint8_t getSquareValue(struct Grid* pGrid, uint16_t x, uint16_t y)
{
    uint64_t square = *getSquarePointer(pGrid, x, y);

    if (countSetBits(square) != 1) return 0;

    uint8_t value = 1;

    uint64_t mask = 1;

    for (; value < pGrid->dimension; mask <<= 1)
    {
        if ((square & mask) != 0)
        {
            return value;
        }

        ++value;
    }

    return value;
}

bool isPossible(struct Grid* pGrid)
{
    return 0 == pGrid->impossibleSquares;
}

bool isComplete(struct Grid* pGrid)
{
    return 0 == pGrid->incompleteSquares;
}

bool mustBeValueByRow(struct Grid* pGrid, uint16_t x, uint16_t y, uint64_t mask)
{
    uint64_t* pSquare = getSquarePointer(pGrid, 0, y);

    for (uint16_t index = 0; index < pGrid->dimension; ++index)
    {
        if (index != x && (*(pSquare + index) & mask))
        {
            return false;
        }
    }

    return true;
}

bool mustBeValueByColumn(struct Grid* pGrid, uint16_t x, uint16_t y, uint64_t mask)
{
    uint64_t* pSquare = getSquarePointer(pGrid, x, 0);

    for (uint16_t index = 0; index < pGrid->dimension; ++index)
    {
        if (index != y && (*pSquare & mask))
        {
            return false;
        }

        pSquare += pGrid->dimension;
    }

    return true;
}

bool mustBeValueBySector(struct Grid* pGrid, uint16_t x, uint16_t y, uint64_t mask)
{
    uint16_t sectorDimension = pGrid->sectorDimension;

    uint64_t* pSquare = getSquarePointer(pGrid,
                                         x / sectorDimension * sectorDimension,
                                         y / sectorDimension * sectorDimension);

    uint64_t bumpSize = pGrid->dimension - sectorDimension + 1;

    uint16_t ignoreIndex = y % sectorDimension * sectorDimension
                         + x % sectorDimension;

    for (uint16_t index = 0; index < pGrid->dimension; ++index)
    {
        if (index != ignoreIndex && (*pSquare & mask))
        {
            return false;
        }

        if ((index + 1) % sectorDimension != 0)
        {
            pSquare += 1;
        }
        else
        {
            pSquare += bumpSize;
        }
    }

    return true;
}

bool mustBeValue(struct Grid* pGrid, uint16_t x, uint16_t y, uint8_t value)
{
    uint64_t mask = toMask(value);

    return mustBeValueByRow   (pGrid, x, y, mask)
        || mustBeValueByColumn(pGrid, x, y, mask)
        || mustBeValueBySector(pGrid, x, y, mask);
}