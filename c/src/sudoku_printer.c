
#include "../include/sudoku_printer.h"

#include <stdio.h>

void writeSquareValue(struct Grid* pGrid, uint16_t x, uint16_t y)
{
    uint16_t possibilities = getPossibilityCount(pGrid, x, y);

    if (possibilities > 1)
    {
        printf(".");
    }
    else if (0 == possibilities)
    {
        printf("!");
    }
    else
    {
        uint8_t value = getSquareValue(pGrid, x, y);

        if (pGrid->sectorDimension <= 3)
        {
            printf("%c", '0' + value);
        }
        else if (value < 11)
        {
            printf("%c", '0' + value - 1);
        }
        else if (value < 37)
        {
            printf("%c", 'A' + value - 11);
        }
        else if (value < 63)
        {
            printf("%c", 'a' + value - 37);
        }
        else if (value == 63)
        {
            printf("$");
        }
        else printf("@");
    }
}

void writeDividerLine(struct Grid* pGrid)
{
    for (uint16_t x = 1; x <= pGrid->dimension; ++x)
    {
        if (x == pGrid->dimension)
        {
            printf("-\r\n");
        }
        else
        {
            printf("--");

            if (x % pGrid->sectorDimension == 0)
            {
                printf("+-");
            }
        }
    }
}

void writeRow(struct Grid* pGrid, uint16_t y)
{
    for (uint16_t x = 1; x <= pGrid->dimension; ++x)
    {
        writeSquareValue(pGrid, x - 1, y);

        if (x != pGrid->dimension)
        {
            printf(" ");

            if (x % pGrid->sectorDimension == 0)
            {
                printf("| ");
            }
        }
    }
}

void writeGridString(struct Grid* pGrid)
{
    printf("\r\n");

    for (uint16_t y = 1; y <= pGrid->dimension; ++y)
    {
        writeRow(pGrid, y - 1);

        if (y != pGrid->dimension)
        {
            printf("\r\n");

            if (y % pGrid->sectorDimension == 0)
            {
                writeDividerLine(pGrid);
            }
        }
    }

    printf("\r\n");
}