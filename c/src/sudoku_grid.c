
#include <stdlib.h>
#include <string.h> 

#include "../include/sudoku_grid.h"

struct GridCache
{
    uint16_t totalSize;
    uint16_t squareSize;
    uint16_t impossibleSquares;
    uint16_t incompleteSquares;
};

struct SquareCache
{
    uint8_t possibilityCount;
    uint8_t squareValue;
};

#define SQUARES_OFFSET (sizeof(struct Grid) + sizeof(struct GridCache))

#define BITS_PER_PACK (sizeof(uint8_t) * 8)

#define getGridCache(pGrid) ((struct GridCache*)(pGrid + sizeof(struct Grid)))

static inline struct SquareCache* getSquarePointer(struct Grid* pGrid, uint16_t x, uint16_t y)
{
    return (struct SquareCache*)pGrid + SQUARES_OFFSET
         + (y * pGrid->dimension + x)
         * getGridCache(pGrid)->squareSize;
}

struct Grid* createGrid(uint16_t sectorDimension)
{
    // We currently overflow pointers with sector size
    // 6 or greater and bigger types slows it down
    //
    if (sectorDimension > 5) return NULL;

    uint16_t dimension = sectorDimension * sectorDimension;

    uint16_t squareSize = sizeof(struct SquareCache)
                        + (dimension - 1) / BITS_PER_PACK
                        + 1;

    uint16_t totalSize = SQUARES_OFFSET + dimension * dimension * squareSize;

    struct Grid* pGrid = malloc(totalSize);

    if (NULL == pGrid) return NULL;

    pGrid->sectorDimension = sectorDimension;
    pGrid->dimension = dimension;
    pGrid->pNext = pGrid;
    pGrid->pPrevious = pGrid;

    struct GridCache* pGridCache = getGridCache(pGrid);

    pGridCache->totalSize = totalSize;
    pGridCache->squareSize = squareSize;
    pGridCache->impossibleSquares = 0;
    pGridCache->incompleteSquares = dimension * dimension;

    memset(pGrid + SQUARES_OFFSET, 0xff, totalSize - SQUARES_OFFSET);

    getSquarePointer(pGrid, 0, 0);

    /*struct SquareCache* pSquareCache;

    for (uint16_t y = 0; y < dimension; ++y)
    for (uint16_t x = 0; x < dimension; ++x)
    {
        pSquareCache = getSquarePointer(pGrid, x, y);

        pSquareCache->possibilityCount = (uint8_t)dimension;
        pSquareCache->squareValue = 0;
    }*/

    gridsInMemory += 1;

    return pGrid;
}

struct Grid* cloneGrid(struct Grid* pGrid)
{
    struct Grid* pClone = malloc(getGridCache(pGrid)->totalSize);

    if (NULL == pClone) return NULL;

    cloneIntoGrid(pGrid, pClone);

    gridsInMemory += 1;

    return NULL;
}

void cloneIntoGrid(struct Grid* pSource, struct Grid* pTarget)
{
    memcpy(pTarget, pSource, getGridCache(pSource)->totalSize);
}

void freeGrid(struct Grid* pGrid)
{
    free(pGrid);

    gridsInMemory -= 1;
}

void setSquareValue(struct Grid* pGrid, uint16_t x, uint16_t y, uint16_t value)
{
    struct SquareCache* pSquareCache = getSquarePointer(pGrid, x, y);

    struct GridCache* pGridCache = getGridCache(pGrid);

    if (0 == pSquareCache->possibilityCount)
    {
        pGridCache->impossibleSquares -= 1;
    }

    if (pSquareCache->possibilityCount != 1)
    {
        pGridCache->incompleteSquares -= 1;
    }

    pSquareCache->possibilityCount = 1;
    pSquareCache->squareValue = (uint8_t)value;

    memset(pSquareCache + sizeof(struct SquareCache),
           0,
           pGridCache->squareSize - sizeof(struct SquareCache));

    uint8_t* pSquare = (uint8_t*)pSquareCache + sizeof(struct SquareCache)
                     + (value - 1) / BITS_PER_PACK;

    *pSquare = *pSquare | (uint8_t)1 << ((value - 1) % BITS_PER_PACK);
}

bool squareHasPossibility(struct Grid* pGrid, uint16_t x, uint16_t y, uint16_t value)
{
    uint16_t* pSquare = (uint16_t*)getSquarePointer(pGrid, x, y)
                      + sizeof(struct SquareCache)
                      + ((value - 1) / BITS_PER_PACK) * sizeof(uint16_t);

    return (*pSquare & (uint8_t)1 << ((value - 1) % BITS_PER_PACK)) != 0;
}

void removeSquarePossibility(struct Grid* pGrid, uint16_t x, uint16_t y, uint16_t value)
{
    struct SquareCache* pSquareCache = getSquarePointer(pGrid, x, y);

    uint16_t* pSquare = (uint16_t*)pSquareCache + sizeof(struct SquareCache)
                      + ((value - 1) / BITS_PER_PACK) * sizeof(uint16_t);

    uint16_t mask = (uint16_t)1 << ((value - 1) % BITS_PER_PACK);

    uint16_t squareValue = *pSquare;

    if ((squareValue | mask) == 0) return;

    *pSquare = squareValue & ~mask;

    pSquareCache->possibilityCount -= 1;

    struct GridCache* pGridCache = getGridCache(pGrid);

    if (0 == pSquareCache->possibilityCount)
    {
        pGridCache->impossibleSquares += 1;
        pGridCache->incompleteSquares += 1;

        pSquareCache->squareValue = 0;
    }
    else if (1 == pSquareCache->possibilityCount)
    {
        pGridCache->incompleteSquares -= 1;

        for (uint16_t possibility = 1; possibility < pGrid->dimension; ++possibility)
        if (squareHasPossibility(pGrid, x, y, possibility))
        {
            pSquareCache->squareValue = (uint8_t)possibility;

            break;
        }
    }
}

uint16_t getPossibilityCount(struct Grid* pGrid, uint16_t x, uint16_t y)
{
    return getSquarePointer(pGrid, x, y)->possibilityCount;
}

uint16_t getSquareValue(struct Grid* pGrid, uint16_t x, uint16_t y)
{
    return getSquarePointer(pGrid, x, y)->squareValue;
}

bool isPossible(struct Grid* pGrid)
{
    return 0 == getGridCache(pGrid)->impossibleSquares;
}

bool isComplete(struct Grid* pGrid)
{
    return 0 == getGridCache(pGrid)->incompleteSquares;
}

bool mustBeValueByRow(struct Grid* pGrid, uint16_t x, uint16_t y, uint16_t value)
{
    uint16_t squareSize = getGridCache(pGrid)->squareSize;

    uint16_t* pSquare = (uint16_t*)pGrid + SQUARES_OFFSET
                      + y * pGrid->dimension * squareSize
                      + sizeof(struct SquareCache)
                      + ((value - 1) / BITS_PER_PACK) * sizeof(uint16_t);

    uint16_t mask = (uint16_t)1 << ((value - 1) % BITS_PER_PACK);

    for (uint16_t index = 0; index < pGrid->dimension; ++index)
    {
        if (index != x && (*pSquare & mask) != 0)
        {
            return false;
        }

        pSquare += squareSize;
    }

    return true;
}

bool mustBeValueByColumn(struct Grid* pGrid, uint16_t x, uint16_t y, uint16_t value)
{
    uint16_t bumpSize = getGridCache(pGrid)->squareSize;

    uint16_t* pSquare = (uint16_t*)pGrid + SQUARES_OFFSET
                      + x * bumpSize + sizeof(struct SquareCache)
                      + ((value - 1) / BITS_PER_PACK) * sizeof(uint16_t);

    uint16_t mask = (uint16_t)1 << ((value - 1) % BITS_PER_PACK);

    bumpSize *= pGrid->dimension;

    for (uint16_t index = 0; index < pGrid->dimension; ++index)
    {
        if (index != y && (*pSquare & mask) != 0)
        {
            return false;
        }

        pSquare += bumpSize;
    }

    return true;
}

bool mustBeValueBySector(struct Grid* pGrid, uint16_t x, uint16_t y, uint16_t value)
{
    uint16_t squareSize = getGridCache(pGrid)->squareSize;

    uint16_t dimension = pGrid->dimension;

    uint16_t sectorDimension = pGrid->sectorDimension;

    uint16_t* pSquare = (uint16_t*)pGrid + SQUARES_OFFSET
                      + (y / sectorDimension * sectorDimension * dimension + x / sectorDimension * sectorDimension) * squareSize
                      + sizeof(struct SquareCache)
                      + ((value - 1) / BITS_PER_PACK) * sizeof(uint16_t);

    uint16_t mask = (uint16_t)1 << ((value - 1) % BITS_PER_PACK);

    uint16_t bumpSize = squareSize * (dimension - sectorDimension + 1);

    uint16_t ignoreIndex = y % sectorDimension * sectorDimension
                         + x % sectorDimension;

    for (uint16_t index = 0; index < pGrid->dimension; ++index)
    {
        if (index != ignoreIndex && (*pSquare & mask) != 0)
        {
            return false;
        }

        if ((index + 1) % sectorDimension != 0)
        {
            pSquare += squareSize;
        }
        else
        {
            pSquare += bumpSize;
        }
    }

    return true;
}