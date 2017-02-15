#sudoku_grid.g
#drinc:util.g

proc insertDividerLine(*char pChar; *Grid_t pGrid) void:
    uint index;
    for index from 1 upto pGrid*.g_dimension do
        if index = pGrid*.g_dimension then
            CharsCopyN(pChar, "-\n", 2);
        else
            CharsCopyN(pChar, "--", 2);
            if index % pGrid*.g_sectorDimension = 0 then
                CharsCopyN(pChar + 2, "+-", 2);
                pChar := pChar + 4;
            else
                pChar := pChar + 2;
            fi;
        fi;
    od;
corp;

proc getSquareChar(*Grid_t pGrid; uint x, y) char:
    uint value;
    value := getSquareValue(pGrid, x, y);
    if pGrid*.g_sectorDimension > 3 then
        if value >= 10 then
            return 'A' + value - 10;
        fi; 
        return '0' + value - 1;
    fi;
    '0' + value
corp;

proc insertRow(*char pChar; *Grid_t pGrid; uint y) void:
    uint x;
    for x from 1 upto pGrid*.g_dimension do
        pChar* := getSquareChar(pGrid, x - 1, y);
        if x = pGrid*.g_dimension then
            (pChar + 1)* := '\n';
        else
            (pChar + 1)* := ' ';
            if x % pGrid*.g_sectorDimension = 0 then
                CharsCopyN(pChar + 2, "| ", 2);
                pChar := pChar + 4;
            else
                pChar := pChar + 2;
            fi;
        fi;
    od;
corp;

proc getGridString(*Grid_t pGrid) *char:
    uint width, height, x, y;
    *char pGridString, pChar;
    if pGrid*.g_sectorDimension > 6 then
        return nil;
    fi;
    width := 2 * pGrid*.g_dimension + 2 * pGrid*.g_sectorDimension - 2;
    height := pGrid*.g_dimension + pGrid*.g_sectorDimension - 1;
    pGridString := Malloc(width * height);
    if pGridString = nil then
        return nil;
    fi;
    pChar := pGridString;
    for y from 1 upto pGrid*.g_dimension do
        insertRow(pChar, pGrid, y - 1);
        pChar := pChar + width;
        if     y % pGrid*.g_sectorDimension = 0
           and y ~= pGrid*.g_dimension then
            insertDividerLine(pChar, pGrid);
            pChar := pChar + width;
        fi;
    od;
    (pChar - 1)* := '\e';
    pGridString
corp;

proc getStateLine(*Grid_t pGrid) *char:
    uint x, y, squareCount;
    *char pStateLine;
    if pGrid*.g_sectorDimension > 6 then
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