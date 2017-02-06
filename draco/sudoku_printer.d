#sudoku_grid.g
#drinc:util.g

proc insertDividerLine(*char pChar; *Grid_t pGrid) *char:
    uint index;
    for index from 1 upto pGrid*.g_dimension do
        CharsCopyN(pChar, "---", 3);
        if index ~= pGrid*.g_dimension then
            (pChar + 3)* := '+';
        else
            (pChar + 3)* := '\n';
        fi;
        pChar := pChar + 4;
    od;
    pChar
corp;

proc getSquareChar(*Grid_t pGrid; uint x, y) char:
    uint value;
    value := getSquareValue(pGrid, x, y);
    if value >= 10 then
        return 'A' - 10 + value;
    fi;
    '0' + value
corp;

proc getGridString(*Grid_t pGrid) *char:
    uint x, y;
    *char pGridString, pChar;
    if pGrid*.g_sectorDimension > 4 then
        return nil;
    fi;
    pGridString := Malloc(4 * pGrid*.g_dimension
                          * (2 * pGrid*.g_dimension - 1));
    if pGridString = nil then
        return nil;
    fi;
    pChar := pGridString;
    for y from 1 upto pGrid*.g_dimension do
        for x from 1 upto pGrid*.g_dimension do
            pChar* := ' ';
            (pChar + 1)* := getSquareChar(pGrid, x - 1, y - 1);
            (pChar + 2)* := ' ';
            if x ~= pGrid*.g_dimension then
                (pChar + 3)* := '|';
            else
                (pChar + 3)* := '\n';
            fi;
            pChar := pChar + 4;
        od;
        if y ~= pGrid*.g_dimension then
            pChar := insertDividerLine(pChar, pGrid);
        fi;
    od;
    (pChar - 1)* := '\e';
    pGridString
corp;

proc getStateLine(*Grid_t pGrid) *char:
    uint x, y, squareCount;
    *char pStateLine;
    if pGrid*.g_sectorDimension > 4 then
        return nil;
    fi;
    squareCount := pGrid*.g_dimension * pGrid*.g_dimension;
    pStateLine := Malloc(squareCount + 1);
    if pStateLine = nil then
        return nil;
    fi;
    for y from 0 upto pGrid*.g_dimension - 1 do
        for x from 0 upto pGrid*.g_dimension - 1 do
            (pStateLine + y * pGrid*.g_dimension + x)* :=
                getSquareChar(pGrid, x, y)
        od;
    od;
    (pStateLine + squareCount)* := '\e';
    pStateLine
corp;