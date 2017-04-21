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

proc attachToFrontIfPossible(*Grid_t pGridList, pGrid;
							 *Counters_t pCounters) *Grid_t:
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

/* TODO: Move this down into squares code */
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
    if pGridList = nil then
        return nil;
    fi;
    if not isPossible(pGridList) then
        pCounters*.c_ImpossibleGrids := pCounters*.c_ImpossibleGrids + 1;
        pGridList := freeFrontGrid(pGridList);
        if pGridList = nil then
            return nil;
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

proc main() void:
    channel output text console;
    *Grid_t pGridList;
    Counters_t counters;
    ulong lastReportTime;
    bool lastReportedCounters;
    gridsInMemory := 0;
    MerrorSet(true);
    open(console);
    pGridList := createGrid(4);
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
        and counters.c_Solutions = 0
    do
        if isComplete(pGridList) then
            counters.c_Solutions := counters.c_Solutions + 1;
            writeln("\n\n\(27)[33mSolution\(27)[0m");
            writeGridString(console, pGridList);
            pGridList := freeFrontGrid(pGridList);
        elif counters.c_Solutions = 0
             and GetCurrentTime() - lastReportTime >= 15 then
            if lastReportedCounters then
                writeln("\n\n\(27)[32mCurrent grid\(27)[0m");
                writeGridString(console, pGridList);
            else
                writeCounters(&counters);
            fi;
            lastReportTime := GetCurrentTime();
            lastReportedCounters := not lastReportedCounters;
        fi;
    od;
    writeCounters(&counters);
    writeln("\n");
    freeGridList(pGridList);
    close(console);
corp;