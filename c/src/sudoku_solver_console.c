
#include "../include/sudoku_solver.h"
#include "../include/sudoku_printer.h"

#include <stdio.h>

void writeTimePeriod(time_t seconds)
{
    if (seconds / 3600 < 10)
    {
        printf("0");
    }
    
    printf("%lli", seconds / 3600);

    seconds %= 3600;

    printf(":%.2lli", seconds / 60);

    seconds %= 60;

    printf(":%.2lli", seconds);
}

void writeCounters(struct Counters* pCounters)
{
    printf("\r\nGrids in memory:              %u", gridsInMemory);
    printf("\r\nElapsed time:                 ");
    writeTimePeriod(time(NULL) - pCounters->startTime);
    printf("\r\nGrids created via splitting:  %u", pCounters->gridSplits);
    printf("\r\nImpossible grids encountered: %u", pCounters->impossibleGrids);
    printf("\r\nGrids lost due to low memory: %u", pCounters->gridsLost);
    printf("\r\nSolutions found:              %u", pCounters->solutions);
    printf("\r\n");
}

int main()
{
    struct Grid* pGridList = createGrid(7);

    if (!pGridList)
    {
        printf("Failed to create initial grid");

        return 1;
    }

    printf("\r\nSearching for %hu x %hu soltuions...\r\n",
           pGridList->dimension,
           pGridList->dimension);

    struct Counters counters = { 0 };

    counters.startTime = time(NULL);

    time_t lastReportTime = time(NULL);

    bool lastReportedCounters = true;

    while (0 == counters.solutions)
    {
        pGridList = advanceSolving(pGridList, &counters);

        if (!pGridList) break;

        if (isComplete(pGridList))
        {
            counters.solutions += 1;

            printf("\r\nSolution:");

            writeGridString(pGridList);

            writeCounters(&counters);

            pGridList = freeFrontGrid(pGridList);
        }
        else if (time(NULL) - lastReportTime >= 15)
        {
            if (lastReportedCounters)
            {
                printf("\r\nCurrent grid:");

                writeGridString(pGridList);
            }
            else writeCounters(&counters);

            lastReportTime = time(NULL);

            lastReportedCounters  = !lastReportedCounters;
        }
    }

    freeGridList(pGridList);

    printf("\r\n");

    return 0;
}