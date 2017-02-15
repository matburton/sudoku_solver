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

proc freeGridEntry(*GridList_t pGridEntry) void:
    freeGrid(pGridEntry*.gl_pGrid);
    free(pGridEntry*.gl_pGrid);
    free(pGridEntry);
corp;

proc freeGridList(*GridList_t pGridList) void:
    *GridList_t pNext;
    while pGridList ~= nil do
        pNext := pGridList*.gl_pNext;
        freeGridEntry(pGridList);
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
                freeGridList(pGridList);
                return nil;
            fi;
            pNext*.gl_pGrid := new(Grid_t);
            if pNext*.gl_pGrid = nil then
                free(pNext);
                freeGridList(pGridList);
                return nil;
            fi;
            if not cloneGrid(pGrid, pNext*.gl_pGrid) then
                free(pNext*.gl_pGrid);
                free(pNext);
                freeGridList(pGridList);
                return nil;
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

proc mustBeValueByRow(*Grid_t pGrid; uint x, y, value) bool:
    uint indexX;
    for indexX from 0 upto pGrid*.g_dimension - 1 do
        if     indexX ~= x
           and squareHasPossibility(pGrid, indexX, y, value) then
            return false;
        fi;
    od;
    true
corp;

proc mustBeValueByColumn(*Grid_t pGrid; uint x, y, value) bool:
    uint indexY;
    for indexY from 0 upto pGrid*.g_dimension - 1 do
        if     indexY ~= y
           and squareHasPossibility(pGrid, x, indexY, value) then
            return false;
        fi;
    od;
    true
corp;

proc mustBeValueBySector(*Grid_t pGrid; uint x, y, value) bool:
    uint indexX, indexY, startX, startY;
    startX := (x / pGrid*.g_sectorDimension) * pGrid*.g_sectorDimension;
    startY := (y / pGrid*.g_sectorDimension) * pGrid*.g_sectorDimension;
    for indexY from startY upto startY + pGrid*.g_sectorDimension - 1 do
        for indexX from startX upto startX + pGrid*.g_sectorDimension - 1 do
            if    (indexX ~= x or indexY ~= y)
               and squareHasPossibility(pGrid, indexX, indexY, value) then
                return false;
            fi;
        od;
    od;  
    true
corp;

/* Returns zero if no value could be deduced */
proc getDeducedValueAt(*Grid_t pGrid; uint x, y) uint:
    uint index;
    if    getSquareValue(pGrid, x, y) ~= 0
       or not isPossibleAt(pGrid, x, y) then
       return 0;
    fi;
    for index from 1 upto pGrid*.g_dimension do
        if    mustBeValueByRow   (pGrid, x, y, index)
           or mustBeValueByColumn(pGrid, x, y, index)
           or mustBeValueBySector(pGrid, x, y, index) then
            return index;
        fi;
    od;
    0
corp;

proc refineGrid(*Grid_t pGrid) void:
    uint indexX, indexY, lastX, lastY, value;
    bool isFirstSquare;
    isFirstSquare := true;
    indexX := 0;
    indexY := 0;
    while lastX ~= indexX or lastY ~= indexY do
        value := getDeducedValueAt(pGrid, indexX, indexY);
        if value ~= 0 then
            setValueAt(pGrid, indexX, indexY, value);
            if not isPossible(pGrid) then
                return;
            fi;
        fi;
        if value ~= 0 or isFirstSquare then
            isFirstSquare := false;
            lastX := indexX;
            lastY := indexY;
        fi;
        if indexX < pGrid*.g_dimension - 1 then
            indexX := indexX + 1;
        else
            indexX := 0;
            if indexY < pGrid*.g_dimension - 1 then
                indexY := indexY + 1;
            else
                indexY := 0;
            fi;
        fi;
    od;
corp;

/* Returns a list with a solution at the front
   or nil if there are no more solutions */
proc getNextSolution(*GridList_t pGridList) *GridList_t:
    *GridList_t pNext, pSplits;
    while pGridList ~= nil do
        refineGrid(pGridList*.gl_pGrid);
        if isComplete(pGridList*.gl_pGrid) then
            return pGridList;
        else
            if isPossible(pGridList*.gl_pGrid) then
                while
                    pSplits := splitGrid(pGridList*.gl_pGrid);
                    pSplits = nil and pGridList*.gl_pNext ~= nil
                do
                    pNext := pGridList;
                    while pNext*.gl_pNext*.gl_pNext ~= nil do
                        pNext := pNext*.gl_pNext;
                    od;
                    freeGridEntry(pNext*.gl_pNext);
                    pNext*.gl_pNext := nil;
                od;
                if pSplits = nil then
                    freeGridEntry(pGridList);
                    return nil;
                fi;
                pGridList := mergeLists(pSplits, pGridList);
            fi;
        fi;
        pNext := pGridList*.gl_pNext;
        freeGridEntry(pGridList);
        pGridList := pNext;
    od;
    nil
corp;

proc main() void:
    channel output text console;
    *GridList_t pGridList, pNext;
    MerrorSet(true);
    open(console);
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
    if not setupGrid(pGridList*.gl_pGrid, 3) then
        free(pGridList*.gl_pGrid);
        free(pGridList);
    fi;
    writeln("");
    while
        pGridList := getNextSolution(pGridList);
        pGridList ~= nil
    do
        writeGridString(console, pGridList*.gl_pGrid);
        writeln('\n');
        pNext := pGridList*.gl_pNext;
        freeGridEntry(pGridList);
        pGridList := pNext;
    od;
    writeln("No further solutions");
    close(console);
corp;