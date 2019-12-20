
#include <stdio.h>

#include "../include/sudoku_grid.h"

int main()
{
    struct Grid* pGrid = createGrid(4);

    //setSquareValue(pGrid, 15, 15, 16);

    //printf("Value at 15,15: %u", getSquareValue(pGrid, 15, 15));

    freeGrid(pGrid);

    return 0;
}