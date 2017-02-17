#sudoku_grid.g
#drinc:util.g

*char TOO_LARGE_EXCUSE = "Can't write-out large grid";

proc getSquareChar(*Grid_t pGrid; uint x, y) char:
    uint value;
    value := getSquareValue(pGrid, x, y);
    if value = 0 then
        return '.';
    fi;
    if pGrid*.g_sectorDimension <= 3 then
        return '0' + value;
    fi;
    if value >= 11 then
        return 'A' + value - 11;
    fi; 
    '0' + value - 1
corp;

proc writeDividerLine(channel output text target; *Grid_t pGrid) void:
    uint x;
    write("\(27)[32m");
    for x from 1 upto pGrid*.g_dimension do
        if x = pGrid*.g_dimension then
            write(target; "-\(27)[0m\n");
        else
            write(target; "--");
            if x % pGrid*.g_sectorDimension = 0 then
                write(target; "+-");
            fi;
        fi;
    od;
corp;

proc writeRow(channel output text target; *Grid_t pGrid; uint y) void:
    uint x;
    for x from 1 upto pGrid*.g_dimension do
        write(target; getSquareChar(pGrid, x - 1, y));
        if x ~= pGrid*.g_dimension then
            write(target; ' ');
            if x % pGrid*.g_sectorDimension = 0 then
                write(target; "\(27)[32m|\(27)[0m ");
            fi;
        fi;
    od;
corp;

proc writeGridString(channel output text target; *Grid_t pGrid) void:
    uint y;
    if pGrid*.g_sectorDimension > 6 then
        write(target; TOO_LARGE_EXCUSE);
    fi;
    for y from 1 upto pGrid*.g_dimension do
        writeRow(target, pGrid, y - 1);
        if y ~= pGrid*.g_dimension then
            write(target; '\n');
            if y % pGrid*.g_sectorDimension = 0 then
                writeDividerLine(target, pGrid);
            fi;
        fi;
    od;
    LineFlush();
corp;

proc writeStateLine(channel output text target; *Grid_t pGrid) void:
    uint x, y;
    if pGrid*.g_sectorDimension > 6 then
        write(target; TOO_LARGE_EXCUSE);
    else
        for y from 0 upto pGrid*.g_dimension - 1 do
            for x from 0 upto pGrid*.g_dimension - 1 do
                write(target; getSquareChar(pGrid, x, y));
            od;
        od;
    fi;
    LineFlush();
corp;