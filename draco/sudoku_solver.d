#sudoku_grid.g
#sudoku_printer.g
#drinc:exec/tasks.g
#drinc:libraries/dos.g
#drinc:util.g

type Counters_t = struct
{
    ulong c_StartTime;
    ulong c_GridSplits;
    ulong c_ImpossibleGrids;
    ulong c_GridsLost;
    ulong c_Solutions;
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

proc isPossible(*Grid_t pGrid) bool:
    uint x, y;
    for y from 0 upto pGrid*.g_dimension - 1 do
        for x from 0 upto pGrid*.g_dimension - 1 do
            if not isSquarePossible(pGrid, x, y) then
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

proc freeFrontGrid(*Grid_t pGridList) *Grid_t:
    *Grid_t pNext;
    pNext := pGridList*.g_pNext;
    freeGrid(pGridList);
    pNext
corp;

proc freeGridList(*Grid_t pGridList) void:
    while pGridList ~= nil do
        pGridList := freeFrontGrid(pGridList);
    od;
corp;

proc freeLastGrid(*Grid_t pGridList) *Grid_t:
    *Grid_t pNext;
    if pGridList*.g_pNext = nil then
        freeGrid(pGridList);
        return nil;
    fi;
    pNext := pGridList;
    while pNext*.g_pNext*.g_pNext ~= nil do
        pNext := pNext*.g_pNext;
    od;
    freeGrid(pNext*.g_pNext);
    pNext*.g_pNext := nil;
    pGridList
corp;

proc splitFirstGridToFront(*Grid_t pGridList;
                           *Counters_t pCounters) *Grid_t:
    uint x, y, count, bestX, bestY, bestCount;
    *Grid_t pGrid, pNewGrid;
    pGrid := pGridList;
    pGridList := pGrid*.g_pNext;
    bestCount := 0;
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
            while
                pNewGrid := cloneGrid(pGrid);
                pNewGrid = nil and pGridList ~= nil
            do
                pGridList := freeLastGrid(pGridList);
                pCounters*.c_GridsLost := pCounters*.c_GridsLost + 1;
            od;
            if pNewGrid ~= nil then
                setValueAt(pNewGrid, bestX, bestY, count);
                pNewGrid*.g_pNext := pGridList;
                pGridList := pNewGrid;
                pCounters*.c_GridSplits := pCounters*.c_GridSplits + 1;
            fi;
        fi;
    od;
    freeGrid(pGrid);
    pGridList
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
       or not isSquarePossible(pGrid, x, y) then
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

/* Returns nil if there are no more solutions */
/* Caller must free front grid if complete before re-calling */
proc advanceSolving(*Grid_t pGridList; *Counters_t pCounters) *Grid_t:
    if not isPossible(pGridList) then
        pGridList := freeFrontGrid(pGridList);
        pCounters*.c_ImpossibleGrids := pCounters*.c_ImpossibleGrids + 1;
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

proc writeCounters(*Grid_t pGridList; *Counters_t pCounters) void:
    uint gridCount;
    gridCount := 0;
    while pGridList ~= nil do
        gridCount := gridCount + 1;
        pGridList := pGridList*.g_pNext;
    od;
    write("\n\n");
    writeln("Grids in list:                ", gridCount);
    write  ("Elapsed time:                 ");
    writeTimePeriod(GetCurrentTime() - pCounters*.c_StartTime);
    writeln("Impossible grids encountered: ", pCounters*.c_ImpossibleGrids);
    writeln("Grids lost due to low memory: ", pCounters*.c_GridsLost);   
    write  ("Solutions found:              ", pCounters*.c_Solutions);
    LineFlush();
corp;

proc main() void:
    channel output text console;
    *Grid_t pGridList;
    Counters_t counters;
    ulong lastReportTime;
    bool lastReportedCounters;
    MerrorSet(true);
    open(console);
    pGridList := createGrid(5);
    if pGridList = nil then
        writeln("Failed to create initial grid");
        return;
    fi;
    write("\nSearching for ", pGridList*.g_dimension,
          " x ", pGridList*.g_dimension, " solutions...");
    LineFlush();
    counters.c_StartTime := GetCurrentTime();
    counters.c_GridSplits := 0;
    counters.c_ImpossibleGrids := 0;
    counters.c_GridsLost := 0;
    counters.c_Solutions := 0;
    lastReportTime := GetCurrentTime();
    lastReportedCounters := true;
    while
        pGridList := advanceSolving(pGridList, &counters);
        pGridList ~= nil and not breakSignaled()
    do
        if isComplete(pGridList) then
            writeln("\n\n\(27)[33mSolution\(27)[0m");
            writeGridString(console, pGridList);
            pGridList := freeFrontGrid(pGridList);
            counters.c_Solutions := counters.c_Solutions + 1;
        else
            if counters.c_Solutions = 0
                and GetCurrentTime() - lastReportTime >= 15 then
                if lastReportedCounters then
                    if isPossible(pGridList) then
                        writeln("\n\n\(27)[32mCurrent grid\(27)[0m");
                    else
                        write("\n\n\(27)[32mBacktracking from");
                        writeln("impossible grid\(27)[0m");
                    fi;
                    writeGridString(console, pGridList);
                else
                    writeCounters(pGridList, &counters);
                fi;
                lastReportTime := GetCurrentTime();
                lastReportedCounters := not lastReportedCounters;
            fi;
        fi;
    od;
    freeGridList(pGridList);
    close(console);
corp;