
#include "../include/sudoku_printer.h"

#include <windows.h>

DWORD getLength(const char* pCharacters)
{
    DWORD length = 0;

    while (*pCharacters++ != 0)
    {
        ++length;
    }

    return length;
}

void write(const char* pCharacters)
{
    DWORD charactersWritten;

    WriteConsole(GetStdHandle(STD_OUTPUT_HANDLE),
                 pCharacters,
                 getLength(pCharacters),
                 &charactersWritten,
                 NULL);
}

void writeCharacter(char character)
{
    DWORD charactersWritten;

    WriteConsole(GetStdHandle(STD_OUTPUT_HANDLE),
                 &character,
                 1,
                 &charactersWritten,
                 NULL);
}

void writeSquareValue(struct Grid* pGrid, uint16_t x, uint16_t y)
{
    uint16_t possibilities = getPossibilityCount(pGrid, x, y);

    if (possibilities > 1)
    {
        writeCharacter('.');
    }
    else if (0 == possibilities)
    {
        writeCharacter('!');
    }
    else
    {
        uint8_t value = getSquareValue(pGrid, x, y);

        if (pGrid->sectorDimension <= 3)
        {
            writeCharacter('0' + value);
        }
        else if (value < 11)
        {
            writeCharacter('0' + value - 1);
        }
        else if (value < 37)
        {
            writeCharacter('A' + value - 11);
        }
        else if (value < 63)
        {
            writeCharacter('a' + value - 37);
        }
        else if (value == 63)
        {
            writeCharacter('$');
        }
        else writeCharacter('@');
    }
}

void writeDividerLine(struct Grid* pGrid)
{
    for (uint16_t x = 1; x <= pGrid->dimension; ++x)
    {
        if (x == pGrid->dimension)
        {
            write("-\r\n");
        }
        else
        {
            write("--");

            if (x % pGrid->sectorDimension == 0)
            {
                write("+-");
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
            writeCharacter(' ');

            if (x % pGrid->sectorDimension == 0)
            {
                write("| ");
            }
        }
    }
}

void writeGridString(struct Grid* pGrid)
{
    write("\r\n");

    for (uint16_t y = 1; y <= pGrid->dimension; ++y)
    {
        writeRow(pGrid, y - 1);

        if (y != pGrid->dimension)
        {
            write("\r\n");

            if (y % pGrid->sectorDimension == 0)
            {
                writeDividerLine(pGrid);
            }
        }
    }

    write("\r\n");
}