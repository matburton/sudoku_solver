
#include "../include/sudoku_solver.h"
#include "../include/sudoku_printer.h"

#include <windows.h>

char writeNumberBuffer [21];

char* toNumberString(ULONGLONG number)
{
    char* pStart = &writeNumberBuffer[20];

    *pStart = '\0';

    if (0 == number)
    {
        *--pStart = '0';
    }
    else
    {
        unsigned int mod = 10;

        while (number > 0)
        {
            *--pStart = '0' + (char)(number % mod);

            number /= mod;
        }
    }

    return pStart;
}

void writeTimePeriod(ULONGLONG milliseconds)
{
    milliseconds /= 1000;

    if (milliseconds / 3600 < 10)
    {
        writeCharacter('0');
    }

    write(toNumberString(milliseconds / 3600));
    
    milliseconds %= 3600;

    writeCharacter(':');

    if (milliseconds / 60 < 10)
    {
        writeCharacter('0');
    }

    write(toNumberString(milliseconds / 60));

    milliseconds %= 60;

    writeCharacter(':');
    write(toNumberString(milliseconds));
}

void writeCounters(struct Counters* pCounters)
{
    write("\r\nGrids in memory: ");
    write(toNumberString(gridsInMemory));

    write("\r\nElapsed time: ");
    writeTimePeriod(GetTickCount64() - pCounters->startTime);

    write("\r\nGrids created via splitting: ");
    write(toNumberString(pCounters->gridSplits));

    write("\r\nImpossible grids encountered: ");
    write(toNumberString(pCounters->impossibleGrids));

    write("\r\nGrids lost due to low memory: ");
    write(toNumberString(pCounters->gridsLost));

    write("\r\nSolutions found: ");
    write(toNumberString(pCounters->solutions));

    write("\r\n");
}

void main()
{
    struct Grid* pGridList = createGrid(8);

    if (!pGridList)
    {
        write("Failed to create initial grid");

        ExitProcess(1);
    }

    write("\r\nSearching for ");
    write(toNumberString(pGridList->dimension));
    write(" x ");
    write(toNumberString(pGridList->dimension));
    write(" soltuions...\r\n");

    struct Counters counters = { 0 };

    counters.startTime = GetTickCount64();

    ULONGLONG lastReportTime = GetTickCount64();

    bool lastReportedCounters = true;

    while (0 == counters.solutions)
    {
        pGridList = advanceSolving(pGridList, &counters);

        if (!pGridList) break;

        if (isComplete(pGridList))
        {
            counters.solutions += 1;

            write("\r\nSolution:");

            writeGridString(pGridList);

            writeCounters(&counters);

            pGridList = freeFrontGrid(pGridList);
        }
        else if (GetTickCount64() - lastReportTime >= 5000)
        {
            if (lastReportedCounters)
            {
                write("\r\nCurrent grid:");

                writeGridString(pGridList);
            }
            else writeCounters(&counters);

            lastReportTime = GetTickCount64();

            lastReportedCounters  = !lastReportedCounters;
        }
    }

    freeGridList(pGridList);

    write("\r\n");

    ExitProcess(0);
}