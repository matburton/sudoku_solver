
#include "../include/sudoku_solver.h"
#include "../include/sudoku_printer.h"

#include <stdio.h>

int main()
{
    struct Grid* pGridList = createGrid(3);

    if (!pGridList)
    {
        printf("Failed to create initial grid");

        return 1;
    }

    struct Counters counters = { 0 };

    while (0 == counters.solutions)
    {
        pGridList = advanceSolving(pGridList, &counters);

        if (!pGridList) break;

        if (isComplete(pGridList))
        {
            counters.solutions += 1;

            printf("Solution:\r\n");

            writeGridString(pGridList);

            pGridList = freeFrontGrid(pGridList);
        }
    }

    freeGridList(pGridList);

    return 0;
}