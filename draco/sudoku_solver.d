#sudoku_grid.g
#sudoku_printer.g
#drinc:util.g

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
    hadPossibility := squareHasPossibility(pGrid, x, y, value);
    removeSquarePossibility(pGrid, x, y, value);
    if hadPossibility then
        value := getSquareValue(pGrid, x, y);
        if value ~= 0 then
            removePossibilitiesRelatedTo(pGrid, x, y, value);
        fi;
    fi;
corp;

proc setValueAt(*Grid_t pGrid; uint x, y, value) void:
    setSquareValue(pGrid, x, y, value);
    removePossibilitiesRelatedTo(pGrid, x, y, value);
corp;

proc getPossibilityCountAt(*Grid_t pGrid; uint x, y) uint:
    uint possibility, count;
    count := 0;
    for possibility from 1 upto pGrid*.g_dimension do
        if squareHasPossibility(pGrid, x, y, possibility) then
            count := count + 1;
        fi;
    od;
    count
corp;

proc isPossibleAt(*Grid_t pGrid; uint x, y) bool:
    uint possibility;
    for possibility from 1 upto pGrid*.g_dimension do
        if squareHasPossibility(pGrid, x, y, possibility) then
            return true;
        fi;
    od;
    false
corp;

proc isPossible(*Grid_t pGrid) bool:
    uint x, y;
    for y from 0 upto pGrid*.g_dimension - 1 do
        for x from 0 upto pGrid*.g_dimension - 1 do
            if not isPossibleAt(pGrid, x, y) then
                return false;
            fi;
        od;
    od;
    true
corp;

proc isComplete(*Grid_t pGrid) bool:
    uint x, y;
    for y from 0 upto pGrid*.g_dimension - 1 do
        for x from 0 upto pGrid*.g_dimension - 1 do
            if getPossibilityCountAt(pGrid, x, y) ~= 1 then
                return false;
            fi;
        od;
    od;
    true
corp;

proc freeGridList(*Grid_t pGridList) void:
    *Grid_t pNext;
    while pGridList ~= nil do
        pNext := pGridList*.g_pNext;
        freeGrid(pGridList);
        pGridList := pNext;
    od;
corp;

proc splitGrid(*Grid_t pGrid) *Grid_t:
    uint x, y, count, bestX, bestY, bestCount;
    *Grid_t pSplitList, pNewGrid;
    bestCount := 0;
    pSplitList := nil;
    for y from 0 upto pGrid*.g_dimension - 1 do
        for x from 0 upto pGrid*.g_dimension - 1 do
            count := getPossibilityCountAt(pGrid, x, y);
            if count > bestCount then
                bestCount := count;
                bestX := x;
                bestY := y;
            fi;
        od;
    od;
    for count from pGrid*.g_dimension downto 1 do
        if squareHasPossibility(pGrid, bestX, bestY, count) then
            pNewGrid := cloneGrid(pGrid);
            if pNewGrid = nil then
                freeGridList(pSplitList);
                return nil;
            fi;
            setValueAt(pNewGrid, bestX, bestY, count);
            pNewGrid*.g_pNext := pSplitList;
            pSplitList := pNewGrid;
        fi;
    od;
    pSplitList
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
    uint value;
    if    getSquareValue(pGrid, x, y) ~= 0
       or not isPossibleAt(pGrid, x, y) then
       return 0;
    fi;
    for value from 1 upto pGrid*.g_dimension do
        if    mustBeValueByRow   (pGrid, x, y, value)
           or mustBeValueByColumn(pGrid, x, y, value)
           or mustBeValueBySector(pGrid, x, y, value) then
            return value;
        fi;
    od;
    0
corp;

proc refineGrid(*Grid_t pGrid) void:
    uint x, y, lastX, lastY, value;
    x := 0;
    y := 0;
    lastX := 0;
    lastY := 0;
    while true do
        value := getDeducedValueAt(pGrid, x, y);
        if value ~= 0 then
            setValueAt(pGrid, x, y, value);
            if not isPossible(pGrid) then
                return;
            fi;
            lastX := x;
            lastY := y;
        fi;
        if x < pGrid*.g_dimension - 1 then
            x := x + 1;
        else
            x := 0;
            y := (y + 1) % pGrid*.g_dimension;
        fi;
        if x = lastX and y = lastY then
            return;
        fi;
    od;
corp;

proc mergeLists(*Grid_t pFrontList, pBackList) void:
    *Grid_t pNext;
    pNext := pFrontList;
    while pNext*.g_pNext ~= nil do
        pNext := pNext*.g_pNext;
    od;
    pNext*.g_pNext := pBackList;
corp;

/* Returns a list with a solution at the front
   or nil if there are no more solutions */
proc getNextSolution(*Grid_t pGridList) *Grid_t:
    *Grid_t pNext;
    while pGridList ~= nil do
        refineGrid(pGridList);
        if isComplete(pGridList) then
            return pGridList;
        else
            if isPossible(pGridList) then
                while
                    pNext := splitGrid(pGridList);
                    pNext = nil and pGridList*.g_pNext ~= nil
                do
                    pNext := pGridList;
                    while pNext*.g_pNext*.g_pNext ~= nil do
                        pNext := pNext*.g_pNext;
                    od;
                    freeGrid(pNext*.g_pNext);
                    pNext*.g_pNext := nil;
                od;
                if pNext = nil then
                    freeGrid(pGridList);
                    return nil;
                fi;
                mergeLists(pNext, pGridList);
                pGridList := pNext;
            fi;
        fi;
        pNext := pGridList*.g_pNext;
        freeGrid(pGridList);
        pGridList := pNext;
    od;
    nil
corp;

proc main() void:
    channel output text console;
    *Grid_t pGridList, pNext;
    MerrorSet(true);
    open(console);
    pGridList := createGrid(3);
    if pGridList = nil then
        writeln("Failed to create initial grid");
        return;
    fi;
    writeln("");
    while
        pGridList := getNextSolution(pGridList);
        pGridList ~= nil
    do
        writeGridString(console, pGridList);
        writeln('\n');
        pNext := pGridList*.g_pNext;
        freeGrid(pGridList);
        pGridList := pNext;
    od;
    writeln("No further solutions found");
    close(console);
corp;