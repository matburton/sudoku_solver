#sudoku_grid.g
#sudoku_printer.g
#drinc:util.g

type GridList_t = struct
{
    *Grid_t     gl_pGrid;
    *GridList_t gl_pNext;
};

extern removePossibilityAt(*Grid_t pGrid; uint x, y, value) void;

proc removePossibilitiesRelatedTo(*Grid_t pGrid; uint x, y, value) void:
    uint indexX, indexY, startX, startY;
    for indexX from 0 upto pGrid*.g_dimension - 1 do
        if indexX ~= x then
            removePossibilityAt(pGrid, indexX, y, value);
        fi;
    od;
    for indexY from 0 upto pGrid*.g_dimension - 1 do
        if indexY ~= y then
            removePossibilityAt(pGrid, x, indexY, value);
        fi;
    od;
    startX := (x / pGrid*.g_sectorDimension) * pGrid*.g_sectorDimension;
    startY := (y / pGrid*.g_sectorDimension) * pGrid*.g_sectorDimension;
    for indexY from startY upto startY + pGrid*.g_sectorDimension - 1 do
        for indexX from startX upto startX + pGrid*.g_sectorDimension - 1 do
            if indexX ~= x and indexY ~= y then
                removePossibilityAt(pGrid, indexX, indexY, value);
            fi;
        od;
    od;
corp;

proc removePossibilityAt(*Grid_t pGrid; uint x, y, value) void:
    bool hadPossibility;
    uint certainValue;
    hadPossibility := squareHasPossibility(pGrid, x, y, value);
    removeSquarePossibility(pGrid, x, y, value);
    if hadPossibility then
        certainValue := getSquareValue(pGrid, x, y);
        if certainValue ~= 0 then
            removePossibilitiesRelatedTo(pGrid, x, y, certainValue);
        fi;
    fi;
corp;

proc setValueAt(*Grid_t pGrid; uint x, y, value) void:
    setSquareValue(pGrid, x, y, value);
    removePossibilitiesRelatedTo(pGrid, x, y, value);
corp;

proc getPossibilityCountAt(*Grid_t pGrid; uint x, y) uint:
    uint index, count;
    count := 0;
    for index from 1 upto pGrid*.g_dimension do
        if squareHasPossibility(pGrid, x, y, index) then
            count := count + 1;
        fi;
    od;
    count
corp;

proc isPossibleAt(*Grid_t pGrid; uint x, y) bool:
    uint index;
    for index from 1 upto pGrid*.g_dimension do
        if squareHasPossibility(pGrid, x, y, index) then
            return true;
        fi;
    od;
    false
corp;

proc isPossible(*Grid_t pGrid) bool:
    uint indexX, indexY;
    for indexY from 0 upto pGrid*.g_dimension - 1 do
        for indexX from 0 upto pGrid*.g_dimension - 1 do
            if not isPossibleAt(pGrid, indexX, indexY) then
                return false;
            fi;
        od;
    od;
    true
corp;

proc isComplete(*Grid_t pGrid) bool:
    uint indexX, indexY;
    for indexY from 0 upto pGrid*.g_dimension - 1 do
        for indexX from 0 upto pGrid*.g_dimension - 1 do
            if getPossibilityCountAt(pGrid, indexX, indexY) ~= 1 then
                return false;
            fi;
        od;
    od;
    true
corp;

proc freeGridList(*GridList_t pGridList) void:
    *GridList_t pNext;
    while pGridList ~= nil do
        pNext := pGridList*.gl_pNext;
        freeGrid(pGridList*.gl_pGrid);
        free(pGridList*.gl_pGrid);
        free(pGridList);
        pGridList := pNext;
    od;
corp;

proc splitGrid(*Grid_t pGrid) *GridList_t:
    uint indexX, indexY, bestX, bestY, bestCount, count;
    *GridList_t pGridList, pNext;
    bestCount := 0;
    pGridList := nil;
    for indexY from 0 upto pGrid*.g_dimension - 1 do
        for indexX from 0 upto pGrid*.g_dimension - 1 do
            count := getPossibilityCountAt(pGrid, indexX, indexY);
            if count > bestCount then
                bestCount := count;
                bestX := indexX;
                bestY := indexY;
            fi;
        od;
    od;
    for count from pGrid*.g_dimension downto 1 do
        if squareHasPossibility(pGrid, bestX, bestY, count) then
            pNext := new(GridList_t);
            if pNext = nil then
                return pGridList;
            fi;
            pNext*.gl_pGrid := new(Grid_t);
            if pNext*.gl_pGrid = nil then
                free(pNext);
                return pGridList;
            fi;
            if not cloneGrid(pGrid, pNext*.gl_pGrid) then
                free(pNext*.gl_pGrid);
                free(pNext);
                return pGridList;
            fi;
            setValueAt(pNext*.gl_pGrid, bestX, bestY, count);
            pNext*.gl_pNext := pGridList;
            pGridList := pNext;
        fi;
    od;
    pGridList
corp;

proc mergeLists(*GridList_t pFrontList, pBackList) *GridList_t:
    *GridList_t pNext;
    pNext := pFrontList;
    while pNext*.gl_pNext ~= nil do
        pNext := pNext*.gl_pNext;
    od;
    pNext*.gl_pNext := pBackList;
    pFrontList
corp;

proc main() void:
    *char pString;
    *GridList_t pGridList, pNext;
    MerrorSet(true);
    pGridList := new(GridList_t);
    if pGridList = nil then
        return;
    fi;
    pGridList*.gl_pNext := nil;
    pGridList*.gl_pGrid := new(Grid_t);
    if pGridList*.gl_pGrid = nil then
        free(pGridList);
        return;
    fi;
    if not setupGrid(pGridList*.gl_pGrid, 2) then
        free(pGridList*.gl_pGrid);
        free(pGridList);
    fi;
    writeln("");
    while pGridList ~= nil do
        pNext := pGridList;
        pGridList := pGridList*.gl_pNext;
        if isComplete(pNext*.gl_pGrid) then
            pString := getGridString(pNext*.gl_pGrid); 
            writeln(pString);
            writeln("");
            Mfree(pString, CharsLen(pString) + 1);
        else
            if isPossible(pNext*.gl_pGrid) then
                pGridList := mergeLists(splitGrid(pNext*.gl_pGrid),
                                        pGridList);
            fi;
        fi;
        freeGrid(pNext*.gl_pGrid);
        free(pNext*.gl_pGrid);
        free(pNext);
    od;
    writeln("No further solutions");
corp;