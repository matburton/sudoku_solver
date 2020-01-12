
#pragma once

#include <stdbool.h>
#include <stdint.h>

struct Grid
{
    uint16_t sectorDimension;
    uint16_t dimension;
    struct Grid* pNext; // Invasive circular doubly linked list
    struct Grid* pPrevious;

    // Private
    //
    uint16_t impossibleSquares;
    uint16_t incompleteSquares;
};

unsigned int gridsInMemory;

// Returns null if the grid couldn't be created for any reason
//
struct Grid* createGrid(uint16_t sectorDimension);

// Returns null if the grid couldn't be cloned for any reason
// This also clones the list pointers
//
struct Grid* cloneGrid(struct Grid* pGrid);

// Source and target are assumed to have the same dimensions
// This also clones the list pointers
//
void cloneIntoGrid(struct Grid* pSource, struct Grid* pTarget);

// Doesn't free other grids in list
//
void freeGrid(struct Grid* pGrid);

void setSquareValue(struct Grid* pGrid, uint16_t x, uint16_t y, uint8_t value);

bool squareHasPossibility(struct Grid* pGrid, uint16_t x, uint16_t y, uint8_t value);

void removeSquarePossibility(struct Grid* pGrid, uint16_t x, uint16_t y, uint8_t value);

uint16_t getPossibilityCount(struct Grid* pGrid, uint16_t x, uint16_t y);

// Returns 0 if the square has multiple possibilities or no possibilities
//
uint8_t getSquareValue(struct Grid* pGrid, uint16_t x, uint16_t y);

bool isPossible(struct Grid* pGrid);

bool isComplete(struct Grid* pGrid);

bool mustBeValueByRow(struct Grid* pGrid, uint16_t x, uint16_t y, uint8_t value);

bool mustBeValueByColumn(struct Grid* pGrid, uint16_t x, uint16_t y, uint8_t value);

bool mustBeValueBySector(struct Grid* pGrid, uint16_t x, uint16_t y, uint8_t value);