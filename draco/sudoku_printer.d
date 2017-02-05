#sudoku_grid.g
#drinc:util.g

proc getGridString(*Grid_t pGrid) *char:
    nil
corp;

proc getStateLine(*Grid_t pGrid) *char:
    uint x, y, squareCount;
    *char pStateLine;
    if pGrid*.g_sectorDimension > 3 then
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
                '0' + getSquareValue(pGrid, x, y);
        od;
    od;
    (pStateLine + squareCount)* := '\e';
    pStateLine
corp;