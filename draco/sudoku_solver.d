#sudoku_grid.g
#sudoku_printer.g
#drinc:exec/tasks.g
#drinc:libraries/dos.g
#drinc:util.g

[256] ushort solution = (7, 12, 13, 16, 6, 8, 14, 15, 1, 3, 4, 5, 9, 10, 11, 2,
                         2, 9, 3, 10, 11, 7, 12, 13, 14, 15, 8, 16, 4, 5, 6, 1,
                         5, 8, 11, 15, 1, 4, 10, 16, 2, 6, 7, 9, 12, 13, 14, 3,
                         1, 4, 6, 14, 2, 3, 5, 9, 10, 11, 12, 13, 15, 7, 16, 8,
                         10, 13, 12, 2, 14, 15, 7, 3, 11, 8, 1, 4, 5, 6, 9, 16,
                         6, 15, 14, 1, 12, 16, 4, 10, 5, 9, 2, 7, 13, 8, 3, 11,
                         4, 11, 16, 9, 5, 1, 6, 8, 13, 12, 3, 10, 7, 14, 2, 15,
                         3, 5, 7, 8, 9, 2, 13, 11, 16, 14, 6, 15, 10, 1, 12, 4,
                         12, 7, 10, 5, 4, 13, 15, 14, 9, 1, 11, 3, 2, 16, 8, 6,
                         14, 1, 8, 3, 10, 9, 16, 5, 12, 2, 13, 6, 11, 4, 15, 7,
                         13, 16, 4, 6, 3, 11, 2, 12, 15, 7, 5, 8, 1, 9, 10, 14,
                         9, 2, 15, 11, 7, 6, 8, 1, 4, 16, 10, 14, 3, 12, 13, 5,
                         8, 10, 9, 7, 13, 14, 3, 2, 6, 5, 15, 1, 16, 11, 4, 12,
                         15, 6, 1, 13, 8, 12, 11, 4, 7, 10, 16, 2, 14, 3, 5, 9,
                         16, 14, 5, 12, 15, 10, 1, 6, 3, 4, 9, 11, 8, 2, 7, 13,
                         11, 3, 2, 4, 16, 5, 9, 7, 8, 13, 14, 12, 6, 15, 1, 10);

type Counters_t = struct
{
    ulong c_StartTime;
    ulong c_GridSplits;
    ulong c_ImpossibleGrids;
    ulong c_GridsLost;
    ulong c_Solutions;
    uint c_MaxCompleteSquares;
    uint c_Entertainment;
};

type Winnder_t = struct
{
    *Grid_t w_pOriginalGrid;
    uint w_Entertainment;
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
    if squareHasPossibility(pGrid, x, y, value) then
        removeSquarePossibility(pGrid, x, y, value);
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

/* Returns zero if no value could be deduced */
proc getDeducedValueAt(*Grid_t pGrid; uint x, y) uint:
    uint value;
    if getPossibilityCount(pGrid, x, y) > 1 then
        for value from 1 upto pGrid*.g_dimension do
            if squareHasPossibility(pGrid, x, y, value)
               and (   mustBeValueByRow   (pGrid, x, y, value)
                    or mustBeValueByColumn(pGrid, x, y, value)
                    or mustBeValueBySector(pGrid, x, y, value)) then
                return value;
            fi;
        od;
    fi;
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

proc detachFrontGrid(*Grid_t pGridList) *Grid_t:
    if pGridList*.g_pNext = pGridList then
        return nil;
    fi;
    pGridList*.g_pNext*.g_pPrevious := pGridList*.g_pPrevious;
    pGridList*.g_pPrevious*.g_pNext := pGridList*.g_pNext;
    pGridList*.g_pNext
corp;

proc freeFrontGrid(*Grid_t pGridList) *Grid_t:
    *Grid_t pGrid;
    pGrid := pGridList;
    pGridList := detachFrontGrid(pGridList);
    freeGrid(pGrid);
    pGridList
corp;

proc freeGridList(*Grid_t pGridList) void:
    while pGridList ~= nil do
        pGridList := freeFrontGrid(pGridList);
    od;
corp;

proc countCompleteSquares(*Grid_t pGrid) uint:
    uint x, y, count;
    count := 0;
    for y from 0 upto pGrid*.g_dimension - 1 do
        for x from 0 upto pGrid*.g_dimension - 1 do
            if getSquareValue(pGrid, x, y) > 1 then
                count := count + 1;
            fi;
        od;
    od;
    count
corp;

proc attachToFrontIfPossible(*Grid_t pGridList, pGrid;
                             *Counters_t pCounters) *Grid_t:
    uint count;
    count := countCompleteSquares(pGrid);
    if pCounters*.c_MaxCompleteSquares < count then
        pCounters*.c_MaxCompleteSquares := count;
    fi;
    if not isPossible(pGrid) then
        pCounters*.c_ImpossibleGrids := pCounters*.c_ImpossibleGrids + 1;
        freeGrid(pGrid);
        return pGridList;
    fi;
    if pGridList = nil then
        pGrid*.g_pNext := pGrid;
        pGrid*.g_pPrevious := pGrid;
    else
        pGrid*.g_pNext := pGridList;
        pGrid*.g_pPrevious := pGridList*.g_pPrevious;
        pGridList*.g_pPrevious*.g_pNext := pGrid;
        pGridList*.g_pPrevious := pGrid;
    fi;
    pGrid
corp;

proc getAPossibilityAt(*Grid_t pGrid; uint x, y) uint:
    uint index;
    for index from 1 upto pGrid*.g_dimension do
        if squareHasPossibility(pGrid, x, y, index) then
            return index;
        fi;
    od;
    0
corp;

/* must not be called with complete or impossible grids */
proc splitFirstGridToFront(*Grid_t pGridList;
                           *Counters_t pCounters) *Grid_t:
    uint x, y, count, bestX, bestY, bestCount, possibility;
    *Grid_t pGrid, pCloneGrid;
    pGrid := pGridList;
    pGridList := detachFrontGrid(pGridList);
    bestCount := 0;
    for y from 0 upto pGrid*.g_dimension - 1 do
        for x from 0 upto pGrid*.g_dimension - 1 do
            count := getPossibilityCount(pGrid, x, y);
            if count > 1 then
                if bestCount = 0 or count < bestCount then
                    bestCount := count;
                    bestX := x;
                    bestY := y;
                fi;
            fi;
        od;
    od;
    possibility := getAPossibilityAt(pGrid, bestX, bestY);
    pCloneGrid := cloneGrid(pGrid);
    if pCloneGrid = nil then
        pCounters*.c_GridsLost := pCounters*.c_GridsLost + 1;
        if pGridList ~= nil then
            pCloneGrid := pGridList*.g_pPrevious;
            pGridList := detachFrontGrid(pGridList*.g_pPrevious);
            cloneIntoGrid(pGrid, pCloneGrid);
        fi;
    fi;
    if pCloneGrid ~= nil then
        pCounters*.c_GridSplits := pCounters*.c_GridSplits + 1;
        removePossibilityAt(pCloneGrid, bestX, bestY, possibility);
        pGridList := attachToFrontIfPossible(pGridList, pCloneGrid, pCounters);
    fi;
    setValueAt(pGrid, bestX, bestY, possibility);
    attachToFrontIfPossible(pGridList, pGrid, pCounters)
corp;

/* Returns nil if there are no more solutions */
/* Caller must free front grid if complete before re-calling */
proc advanceSolving(*Grid_t pGridList; *Counters_t pCounters) *Grid_t:
    uint count;
    if pGridList = nil then
        return nil;
    fi;
    if not isPossible(pGridList) then
        pCounters*.c_ImpossibleGrids := pCounters*.c_ImpossibleGrids + 1;
        count := countCompleteSquares(pGridList);
        if pCounters*.c_MaxCompleteSquares < count then
            pCounters*.c_MaxCompleteSquares := count;
        fi;
        pGridList := freeFrontGrid(pGridList);
        if pGridList = nil then
            return nil;
        else
            count := pCounters*.c_MaxCompleteSquares - countCompleteSquares(pGridList);
            if pCounters*.c_Entertainment < count then
                pCounters*.c_Entertainment := count;
            fi;
        fi;
    fi;
    refineGrid(pGridList);
    if not isComplete(pGridList) and isPossible(pGridList) then
        pGridList := splitFirstGridToFront(pGridList, pCounters);
    fi;
    pGridList
corp;

proc breakSignaled() bool:
    SetSignal(0, 0) & SIGBREAKF_CTRL_C ~= 0
corp;

proc writeTimePeriod(ulong seconds) void:
    if seconds / 3600 < 10 then
        write('0');
    fi;
    write(seconds / 3600);
    seconds := seconds % 3600;
    write(":", (seconds / 60):-2);
    seconds := seconds % 60;
    writeln(":", seconds:-2);
corp;

proc writeCounters(*Counters_t pCounters) void:
    write  ("\n\n");
    writeln("Grids in memory:              ", gridsInMemory);
    write  ("Elapsed time:                 ");
    writeTimePeriod(GetCurrentTime() - pCounters*.c_StartTime);
    writeln("Grids created via splitting:  ", pCounters*.c_GridSplits);
    writeln("Impossible grids encountered: ", pCounters*.c_ImpossibleGrids);
    writeln("Grids lost due to low memory: ", pCounters*.c_GridsLost);   
    write  ("Solutions found:              ", pCounters*.c_Solutions);
    LineFlush();
corp;

proc solve(*Grid_t pGridList; *Counters_t pCounters) *Grid_t:
    while
        pGridList := advanceSolving(pGridList, pCounters);
        pGridList ~= nil and not breakSignaled()
    do
        if isComplete(pGridList) then
            pCounters*.c_Solutions := 1;
            return pGridList;
        fi;
    od;
    pGridList
corp;

proc main() void:
    Winnder_t winner;
    channel output text console;
    *Grid_t pGridList, pOriginalGrid;
    Counters_t counters;
    int indexA, indexB, indexC, x, y;
    gridsInMemory := 0;
    MerrorSet(true);
    open(console);
    winner.w_Entertainment := 0;
    winner.w_pOriginalGrid := nil;
    for indexC from 0 upto 15 do
        for indexA from 15 downto 0 do
            for indexB from 15 downto 0 do
                pOriginalGrid := createGrid(4);
                setValueAt(pOriginalGrid, 2, 1, 3);
                setValueAt(pOriginalGrid, 6, 4, 7);
                x := 4 + (indexA / 4);
                y := 8 + (indexA % 4);
                setValueAt(pOriginalGrid, x, y, solution[y * 16 + x]);
                x := 0 + (indexB / 4);
                y := 12 + (indexB % 4);
                setValueAt(pOriginalGrid, x, y, solution[y * 16 + x]);
                x := 8 + (indexC / 4);
                y := 4 + (indexC % 4);
                setValueAt(pOriginalGrid, x, y, solution[y * 16 + x]);
                pGridList := cloneGrid(pOriginalGrid);
                pGridList*.g_pNext := pGridList;
                pGridList*.g_pPrevious := pGridList;
                counters := Counters_t(0, 0, 0, 0, 0, 0, 0);
                pGridList := solve(pGridList, &counters);
                freeGridList(pGridList);
                if breakSignaled() then
                    freeGridList(winner.w_pOriginalGrid);
                    freeGridList(pOriginalGrid);
                    close(console);
                    return;
                fi;
                if counters.c_Solutions = 1 and counters.c_Entertainment >= winner.w_Entertainment then
                    freeGridList(winner.w_pOriginalGrid);
                    winner.w_pOriginalGrid := pOriginalGrid;
                    winner.w_Entertainment := counters.c_Entertainment;
                    writeln("\nNew winner with entertainment rating of ", counters.c_Entertainment);
                    writeln("(Impossible grids encountered ", counters.c_ImpossibleGrids, ")\n");
                    writeGridString(console, pOriginalGrid);
                    write("\n");
                else
                    freeGridList(pOriginalGrid);
                fi;
            od;
        od;
    od;
    freeGridList(winner.w_pOriginalGrid);
    close(console);
corp;