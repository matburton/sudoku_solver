#drinc:exec/miscellaneous.g
#drinc:exec/ports.g
#drinc:exec/tasks.g
#drinc:graphics/gfx.g
#drinc:graphics/rastport.g
#drinc:libraries/dos.g
#drinc:libraries/dosextens.g
#drinc:intuition/border.g
#drinc:intuition/intuiMessage.g
#drinc:intuition/intuiText.g
#drinc:intuition/gadget.g
#drinc:intuition/miscellaneous.g
#drinc:intuition/screen.g
#drinc:intuition/window.g
#drinc:util.g
#sudoku_grid.g
#sudoku_printer.g
#sudoku_solver.g

type SquareGadget_t = struct {
    Gadget_t sg_Gadget;
    StringInfo_t sg_StringInfo;
    [6] char sg_TextBuffer;
    long sg_PreviousValue;
};

type buttonBorderXY = [6] int;

[10] int squareGadgetBorderXY = (0,  0,  0,  10, 30, 10, 30, 0, 0, 0);

Border_t squareGadgetBorder;

extern _d_IO_initialize() void;

channel output text out;

proc devNullChar(char c) void:
corp;

proc setupSquareGadget(*SquareGadget_t pSquareGadget; int dimension) void:
    pSquareGadget*.sg_Gadget := Gadget_t(nil, /* g_NextGadget */
                                         0, /* g_LeftEdge */
                                         0, /* g_TopEdge */
                                         24, /* g_Width */
                                         5, /* g_Height */
                                         0, /* g_Flags */
                                         LONGINT | STRINGCENTER | RELVERIFY, /* g_Activation */
                                         STRGADGET, /* g_GadgetType */
                                         (nil), /* g_GadgetRender */
                                         (nil), /* g_SelectRender */
                                         nil, /* g_GadgetText */
                                         0, /* g_MutualExclude */
                                         (nil), /* g_SpecialInfo */
                                         0, /* g_GadgetID */
                                         nil); /* g_UserData */
    pSquareGadget*.sg_Gadget.g_GadgetRender.gBorder := &squareGadgetBorder;
    pSquareGadget*.sg_Gadget.g_SpecialInfo.gStr := &pSquareGadget*.sg_StringInfo;
    pSquareGadget*.sg_Gadget.g_UserData := pretend(pSquareGadget, *byte);
    pSquareGadget*.sg_StringInfo := StringInfo_t(nil, nil, 0, 0, 0, 0, 0, 0, 0, 0, nil, 0, nil);
    pSquareGadget*.sg_StringInfo.si_MaxChars := 3;
    if dimension < 16 then
        pSquareGadget*.sg_StringInfo.si_MaxChars := 2;
    fi;
    pSquareGadget*.sg_StringInfo.si_Buffer := &pSquareGadget*.sg_TextBuffer[0];
    pSquareGadget*.sg_StringInfo.si_UndoBuffer := &pSquareGadget*.sg_TextBuffer[3];
    BlockFill(&pSquareGadget*.sg_TextBuffer[0], 6, pretend('\e', byte));
    pSquareGadget*.sg_PreviousValue := 0;
corp;

proc getSquareGadget(*SquareGadget_t pSquareGadgets; int dimension, x, y) *SquareGadget_t:
    pSquareGadgets + (y * dimension + x) * sizeof(SquareGadget_t)
corp;

proc createSquareGadgets(int dimension, leftEdge, topEdge) *SquareGadget_t:
    *SquareGadget_t pSquareGadgets, pSquareGadget;
    *Gadget_t pPreviousGadget;
    int x, y;
    pSquareGadgets := pretend(Malloc(sizeof(SquareGadget_t) * dimension * dimension), *SquareGadget_t);
    if pSquareGadgets = nil then
        return nil;
    fi;
    pPreviousGadget := nil;
    for y from dimension - 1 downto 0 do
        for x from dimension - 1 downto 0 do
            pSquareGadget := getSquareGadget(pSquareGadgets, dimension, x, y);
            setupSquareGadget(pSquareGadget, dimension);
            pSquareGadget*.sg_Gadget.g_LeftEdge := leftEdge + x * 32;
            pSquareGadget*.sg_Gadget.g_TopEdge := topEdge + y * 12;
            pSquareGadget*.sg_Gadget.g_NextGadget := pPreviousGadget;
            pPreviousGadget := &pSquareGadget*.sg_Gadget;
        od;
    od;
    pSquareGadgets
corp;

proc freeSquareGadgets(*SquareGadget_t pSquareGadgets; int dimension) void:
    Mfree(pSquareGadgets, sizeof(SquareGadget_t) * dimension * dimension);
corp;

proc drawSectorLines(*Window_t pWindow; int sectorDimension) void:
    int dimension, index, start;
    dimension := sectorDimension * sectorDimension;
    SetAPen(pWindow*.w_RPort, 1);
    for index from 1 upto sectorDimension - 1 do
        start := 3 + 32 * sectorDimension * index;
        Move(pWindow*.w_RPort, start, 11);
        Draw(pWindow*.w_RPort, start, 9 + 12 * dimension);
        start := 10 + 12 * sectorDimension * index;
        Move(pWindow*.w_RPort, 4, start);
        Draw(pWindow*.w_RPort, 2 + 32 * dimension, start);
    od;
corp;

proc createGridFromSquareGadgets(int sectorDimension; *SquareGadget_t pSquareGadgets) *Grid_t:
    *Grid_t pGrid;
    int dimension, x, y;
    *SquareGadget_t pSquareGadget;
    dimension := sectorDimension * sectorDimension;
    pGrid := createGrid(sectorDimension);
    if pGrid = nil then
        return nil;
    fi;
    for y from dimension - 1 downto 0 do
        for x from dimension - 1 downto 0 do
            pSquareGadget := getSquareGadget(pSquareGadgets, dimension, x, y);
            if pSquareGadget*.sg_StringInfo.si_LongInt ~= 0 then
                setValueAt(pGrid, x, y, pSquareGadget*.sg_StringInfo.si_LongInt);
            fi;
        od;
    od;
    pGrid
corp;

proc toggleSolveButton(*Window_t pWindow; *Gadget_t pGadget) void:
    if pGadget*.g_Flags & SELECTED = 0 then
        pGadget*.g_GadgetText*.it_IText := "Cancel";
    else
        pGadget*.g_GadgetText*.it_IText := "Solve";
    fi;
    SetAPen(pWindow*.w_RPort, 0);
    RectFill(pWindow*.w_RPort, pGadget*.g_LeftEdge, pGadget*.g_TopEdge, pGadget*.g_LeftEdge + pGadget*.g_Width, pGadget*.g_TopEdge + pGadget*.g_Height);
    RefreshGList(pGadget, pWindow, nil, 1);
corp;

proc updateSquareGadgetValue(*Window_t pWindow; *SquareGadget_t pSquareGadget; long value) void:
    uint gadgetFlags;
    channel output text squareGadgetTextBuffer;  
    if pSquareGadget*.sg_StringInfo.si_LongInt = value then
        return;
    fi;
    pSquareGadget*.sg_StringInfo.si_LongInt := value;
    BlockFill(&pSquareGadget*.sg_TextBuffer[0], 3, pretend('\e', byte));
    if value ~= 0 then
        open(squareGadgetTextBuffer, &pSquareGadget*.sg_TextBuffer[0]);
        write(squareGadgetTextBuffer; value);
        close(squareGadgetTextBuffer);
    fi;
    gadgetFlags := pSquareGadget*.sg_Gadget.g_Flags;
    pSquareGadget*.sg_Gadget.g_Flags := gadgetFlags & ~GADGDISABLED;
    RefreshGList(&pSquareGadget*.sg_Gadget, pWindow, nil, 1);
    pSquareGadget*.sg_Gadget.g_Flags := gadgetFlags;
corp;

proc updateSquareGadgetValues(*Window_t pWindow; *SquareGadget_t pSquareGadgets; *Grid_t pGrid) void:
    int x, y;
    *SquareGadget_t pSquareGadget;
    for x from 0 upto pGrid*.g_dimension - 1 do
        for y from 0 upto pGrid*.g_dimension - 1 do
            pSquareGadget := getSquareGadget(pSquareGadgets, pGrid*.g_dimension, x, y);
            updateSquareGadgetValue(pWindow, pSquareGadget, getSquareValue(pGrid, x, y));
        od;
    od;
corp;

proc toggleSquareGadgetsEnabled(int dimension; *SquareGadget_t pSquareGadgets) void:
    int x, y;
    *SquareGadget_t pSquareGadget;
    for x from 0 upto dimension - 1 do
        for y from 0 upto dimension - 1 do           
            pSquareGadget := getSquareGadget(pSquareGadgets, dimension, x, y);
            pSquareGadget*.sg_Gadget.g_Flags := pSquareGadget*.sg_Gadget.g_Flags >< GADGDISABLED;
        od;
    od;
corp;

proc restorePreviousValues(*Window_t pWindow; int dimension; *SquareGadget_t pSquareGadgets) void:
    int x, y;
    *SquareGadget_t pSquareGadget;
    for x from 0 upto dimension - 1 do
        for y from 0 upto dimension - 1 do
            pSquareGadget := getSquareGadget(pSquareGadgets, dimension, x, y);
            updateSquareGadgetValue(pWindow, pSquareGadget, pSquareGadget*.sg_PreviousValue);
        od;
    od;
corp;

proc eventLoop(*Window_t pWindow; int sectorDimension; *SquareGadget_t pSquareGadgets) void:  
    int dimension;
    *IntuiMessage_t pMessage;
    *Gadget_t pGadget;
    *SquareGadget_t pSquareGadget;
    ulong signals, messageClass@signals, lastWroteCountersTime;
    *Grid_t pGridList;
    Counters_t counters;
    dimension := sectorDimension * sectorDimension;
    pGridList := nil;
    while not breakSignaled() do
        if pGridList = nil then       
            signals := Wait((1 << pWindow*.w_UserPort*.mp_SigBit) | SIGBREAKF_CTRL_C);
            if signals & SIGBREAKF_CTRL_C ~= 0 then
                freeGridList(pGridList);
                return;
            fi;
        fi;
        while
            pMessage := pretend(GetMsg(pWindow*.w_UserPort), *IntuiMessage_t);
            pMessage ~= nil
        do
            messageClass := pMessage*.im_Class;
            pGadget := pretend(pMessage*.im_IAddress, *Gadget_t);
            ReplyMsg(pretend(pMessage, *Message_t));        
            case messageClass
                incase CLOSEWINDOW:
                    freeGridList(pGridList);
                    return;
                incase MENUPICK:
                    writeln(out; "MENUPICK");
                incase GADGETUP:
                    if pGadget*.g_Activation & LONGINT ~= 0 then
                        pSquareGadget := pretend(pGadget*.g_UserData, *SquareGadget_t);
                        if pSquareGadget*.sg_StringInfo.si_Buffer* ~= '\e'
                           and (   pSquareGadget*.sg_StringInfo.si_LongInt < 1
                                or pSquareGadget*.sg_StringInfo.si_LongInt > dimension) then
                            DisplayBeep(nil);
                            updateSquareGadgetValue(pWindow, pSquareGadget, pSquareGadget*.sg_PreviousValue);
                        else
                            pSquareGadget*.sg_PreviousValue := pSquareGadget*.sg_StringInfo.si_LongInt;
                        fi;
                    else
                        if pGridList = nil then
                            toggleSquareGadgetsEnabled(dimension, pSquareGadgets);
                            pGridList := createGridFromSquareGadgets(sectorDimension, pSquareGadgets);
                            if pGridList = nil then
                                writeln(out; "Failed to create grid");
                                DisplayBeep(nil);
                                pGadget*.g_Flags := pGadget*.g_Flags >< SELECTED;
                            else
                                counters := Counters_t(0, 0, 0, 0, 0);
                                counters.c_StartTime := GetCurrentTime();
                                lastWroteCountersTime := GetCurrentTime();
                            fi;
                        else
                            restorePreviousValues(pWindow, dimension, pSquareGadgets);
                            toggleSquareGadgetsEnabled(dimension, pSquareGadgets);
                            freeGridList(pGridList);
                            pGridList := nil;
                        fi;
                        toggleSolveButton(pWindow, pGadget);
                    fi;
            esac;
        od;
        if pGridList ~= nil then
            if GetCurrentTime() - lastWroteCountersTime >= 5 then
                writeCounters(out, &counters);
                lastWroteCountersTime := GetCurrentTime();
            fi;
            updateSquareGadgetValues(pWindow, pSquareGadgets, pGridList);
            pGridList := advanceSolving(pGridList, &counters);
            if pGridList = nil or isComplete(pGridList) then
                if pGridList ~= nil then
                    updateSquareGadgetValues(pWindow, pSquareGadgets, pGridList);
                    writeln(out; "\n\(27)[33mSolution\(27)[0m");
                    writeGridString(out, pGridList);
                    counters.c_Solutions := counters.c_Solutions + 1;
                else
                    restorePreviousValues(pWindow, dimension, pSquareGadgets);
                fi;
                writeCounters(out, &counters);
                freeGridList(pGridList);               
                pGridList := nil;
                pGadget*.g_Flags := pGadget*.g_Flags >< SELECTED;
                toggleSolveButton(pWindow, pGadget);
                toggleSquareGadgetsEnabled(dimension, pSquareGadgets);
            fi;
        fi;
    od;
    freeGridList(pGridList);
corp;

proc createWindow(int sectorDimension) void:
    int dimension;
    *SquareGadget_t pSquareGadgets;
    NewWindow_t newWindow;
    Gadget_t buttonGadget;
    Border_t buttonBorderA, buttonBorderB;
    [6] int buttonBorderAXY,buttonBorderBXY;
    IntuiText_t buttonText;
    *Window_t pWindow;
    dimension := sectorDimension * sectorDimension;
    pSquareGadgets := createSquareGadgets(dimension, 6, 13);
    if pSquareGadgets = nil then
        writeln(out; "Failed to create gadgets");
        DisplayBeep(nil);
        return;
    fi;
    buttonGadget := Gadget_t(nil, /* g_NextGadget */
                             4, /* g_LeftEdge */
                             0, /* g_TopEdge */
                             0, /* g_Width */
                             15,   /* g_Height */
                             GADGHCOMP, /* g_Flags */
                             RELVERIFY | TOGGLESELECT , /* g_Activation */
                             BOOLGADGET, /* g_GadgetType */
                             (nil), /* g_GadgetRender */
                             (nil), /* g_SelectRender */
                             nil, /* g_GadgetText */
                             0, /* g_MutualExclude */
                             (nil), /* g_SpecialInfo */
                             0, /* g_GadgetID */
                             nil); /* g_UserData */
    buttonGadget.g_TopEdge := 12 * (dimension - 1) + 23;
    buttonGadget.g_Width := 32 * (dimension - 1) + 31;
    buttonGadget.g_NextGadget := &pSquareGadgets*.sg_Gadget;
    buttonGadget.g_GadgetRender.gBorder := &buttonBorderA;
    buttonGadget.g_GadgetText := &buttonText;
    buttonBorderA := Border_t(0, 0, 2, 0, 0, 3, nil, nil);
    buttonBorderA.b_XY := &buttonBorderAXY[0];
    buttonBorderA.b_NextBorder := &buttonBorderB;
    buttonBorderB := Border_t(0, 0, 1, 0, 0, 3, nil, nil);
    buttonBorderB.b_XY := &buttonBorderBXY[0];
    buttonBorderAXY := buttonBorderXY(0, 0, 0, 0, 0, 0);
    buttonBorderBXY := buttonBorderXY(0, 0, 0, 0, 0, 0);
    buttonBorderAXY[1] := buttonGadget.g_Height - 1;
    buttonBorderAXY[4] := buttonGadget.g_Width - 1;
    buttonBorderBXY[0] := buttonGadget.g_Width - 1;
    buttonBorderBXY[2] := buttonGadget.g_Width - 1;
    buttonBorderBXY[3] := buttonGadget.g_Height - 1;
    buttonBorderBXY[5] := buttonGadget.g_Height - 1;
    buttonText := IntuiText_t(1, 0, 0, 0, 4, nil, nil, nil);
    buttonText.it_LeftEdge := buttonGadget.g_Width / 2 - 20;
    newWindow := NewWindow_t(50,
                             15,
                             0,
                             0,
                             FREEPEN,
                             FREEPEN,
                             CLOSEWINDOW | MENUPICK | GADGETUP,
                             SMART_REFRESH | ACTIVATE | WINDOWDEPTH | WINDOWCLOSE | WINDOWDRAG | NOCAREREFRESH,
                             nil,
                             nil,
                             nil,
                             nil,
                             nil,
                             0,
                             0,
                             0,
                             0,
                             WBENCHSCREEN);
    newWindow.nw_Width := buttonGadget.g_Width + 8;
    newWindow.nw_Height := buttonGadget.g_TopEdge + buttonGadget.g_Height + 2;
    newWindow.nw_FirstGadget := &buttonGadget;
    newWindow.nw_Title := "Sudoku solver";
    buttonText.it_IText := "Solve";
    pWindow := OpenWindow(&newWindow);
    if pWindow = nil then
        writeln(out; "Failed to create window");
        DisplayBeep(nil);
    else
        buttonGadget.g_Flags := buttonGadget.g_Flags | SELECTED;
        RefreshGList(&buttonGadget, pWindow, nil, 1);
        drawSectorLines(pWindow, sectorDimension);
        eventLoop(pWindow, sectorDimension, pSquareGadgets);
        CloseWindow(pWindow); 
    fi;
    freeSquareGadgets(pSquareGadgets, dimension);
corp;

proc main() void:
    *Process_t pProcess;
    *Message_t pWorkbenchStartup;
    squareGadgetBorder := Border_t(-2, -2, 2, 0, 0, 5, nil, nil);
    squareGadgetBorder.b_XY := &squareGadgetBorderXY[0];
    pWorkbenchStartup := nil;
    MerrorSet(true);
    if OpenExecLibrary(0) ~= nil then
        pProcess := pretend(FindTask(nil), *Process_t);
        if pretend(pProcess*.pr_CLI, arbptr) = nil then
            ignore(WaitPort(&pProcess*.pr_MsgPort));
            pWorkbenchStartup := GetMsg(&pProcess*.pr_MsgPort);
        fi;
        if OpenDosLibrary(0) ~= nil then
            if OpenIntuitionLibrary(0) ~= nil then
                if OpenGraphicsLibrary(0) ~= nil then
                    _d_IO_initialize();
                    if pWorkbenchStartup ~= nil then
                        open(out, devNullChar);
                    else
                        open(out);
                    fi;
                    createWindow(4);
                    write(out; '\n');
                    close(out);
                    CloseGraphicsLibrary();
                fi;
                CloseIntuitionLibrary();
            fi;
            CloseDosLibrary();
        fi;
        CloseExecLibrary();
    fi;
    if pWorkbenchStartup ~= nil then
        Forbid();
        ReplyMsg(pWorkbenchStartup);
    fi;
corp;