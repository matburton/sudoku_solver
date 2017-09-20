#drinc:exec/miscellaneous.g
#drinc:exec/memory.g
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
#drinc:intuition/menu.g
#drinc:intuition/miscellaneous.g
#drinc:intuition/screen.g
#drinc:intuition/window.g
#drinc:util.g
#sudoku_grid.g
#sudoku_solver.g

[36] uint BUSY_POINTER = (0x0000, 0x0000,
                          0x0400, 0x07C0,
                          0x0000, 0x07C0,
                          0x0100, 0x0380,
                          0x0000, 0x07E0,
                          0x07C0, 0x1FF8,
                          0x1FF0, 0x3FEC,
                          0x3FF8, 0x7FDE,
                          0x3FF8, 0x7FBE,
                          0x7FFC, 0xFF7F,
                          0x7EFC, 0xFFFF,
                          0x7FFC, 0xFFFF,
                          0x3FF8, 0x7FFE,
                          0x3FF8, 0x7FFE,
                          0x1FF0, 0x3FFC,
                          0x07C0, 0x1FF8,
                          0x0000, 0x07E0,
                          0x0000, 0x0000);

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

*uint pBusyPointer;

proc devNullChar(char c) void:
corp;

proc setupSquareGadget(*SquareGadget_t pSquareGadget; uint dimension) void:
    pSquareGadget*.sg_Gadget := Gadget_t(nil, /* g_NextGadget */
                                         0, /* g_LeftEdge */
                                         0, /* g_TopEdge */
                                         24, /* g_Width */
                                         5, /* g_Height */
                                         0, /* g_Flags */
                                         LONGINT | STRINGCENTER | GADGIMMEDIATE, /* g_Activation */
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

proc getSquareGadget(*SquareGadget_t pSquareGadgets; uint dimension, x, y) *SquareGadget_t:
    pSquareGadgets + (y * dimension + x) * sizeof(SquareGadget_t)
corp;

proc createSquareGadgets(uint dimension, leftEdge, topEdge) *SquareGadget_t:
    *SquareGadget_t pSquareGadgets, pSquareGadget;
    *Gadget_t pPreviousGadget;
    uint x, y;
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

proc freeSquareGadgets(*SquareGadget_t pSquareGadgets; uint dimension) void:
    Mfree(pSquareGadgets, sizeof(SquareGadget_t) * dimension * dimension);
corp;

proc drawSectorLines(*Window_t pWindow; uint sectorDimension) void:
    uint dimension, index, start;
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

proc createGridFromSquareGadgets(uint sectorDimension; *SquareGadget_t pSquareGadgets) *Grid_t:
    *Grid_t pGrid;
    uint dimension, x, y;
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
    uint x, y;
    *SquareGadget_t pSquareGadget;
    for x from 0 upto pGrid*.g_dimension - 1 do
        for y from 0 upto pGrid*.g_dimension - 1 do
            pSquareGadget := getSquareGadget(pSquareGadgets, pGrid*.g_dimension, x, y);
            updateSquareGadgetValue(pWindow, pSquareGadget, getSquareValue(pGrid, x, y));
        od;
    od;
corp;

proc toggleSquareGadgetsEnabled(uint dimension; *SquareGadget_t pSquareGadgets) void:
    uint x, y;
    *SquareGadget_t pSquareGadget;
    for x from 0 upto dimension - 1 do
        for y from 0 upto dimension - 1 do           
            pSquareGadget := getSquareGadget(pSquareGadgets, dimension, x, y);
            pSquareGadget*.sg_Gadget.g_Flags := pSquareGadget*.sg_Gadget.g_Flags >< GADGDISABLED;
        od;
    od;
corp;

proc stashCurrentValues(*Window_t pWindow; uint dimension; *SquareGadget_t pSquareGadgets) void:
    uint x, y;
    *SquareGadget_t pSquareGadget;
    for x from 0 upto dimension - 1 do
        for y from 0 upto dimension - 1 do
            pSquareGadget := getSquareGadget(pSquareGadgets, dimension, x, y);
            pSquareGadget*.sg_PreviousValue := pSquareGadget*.sg_StringInfo.si_LongInt;
        od;
    od;
corp;

proc restorePreviousValues(*Window_t pWindow; uint dimension; *SquareGadget_t pSquareGadgets) void:
    uint x, y;
    *SquareGadget_t pSquareGadget;
    for x from 0 upto dimension - 1 do
        for y from 0 upto dimension - 1 do
            pSquareGadget := getSquareGadget(pSquareGadgets, dimension, x, y);
            updateSquareGadgetValue(pWindow, pSquareGadget, pSquareGadget*.sg_PreviousValue);
            pSquareGadget*.sg_PreviousValue := 0;
        od;
    od;
corp;

proc setText(*Window_t pWindow; *Gadget_t pTextGadget; *char pText) void:
    *StringInfo_t pStringInfo;  
    pStringInfo := pTextGadget*.g_SpecialInfo.gStr;
    BlockFill(pStringInfo*.si_Buffer, pStringInfo*.si_MaxChars, pretend('\e', byte));
    if pText ~= nil then
        CharsCopyN(pStringInfo*.si_Buffer, pText, pStringInfo*.si_MaxChars - 1);
    fi;
    pTextGadget*.g_Flags := pTextGadget*.g_Flags & ~GADGDISABLED;
    RefreshGList(pTextGadget, pWindow, nil, 1);
    pTextGadget*.g_Flags := pTextGadget*.g_Flags | GADGDISABLED;
    if pText ~= nil then
        SetWindowTitles(pWindow, pretend(-1, *char), pText);
    else
        SetWindowTitles(pWindow, pretend(-1, *char), "Sudoku solver");
    fi;
corp;

proc valuesAreValid(*Window_t pWindow; uint dimension; *SquareGadget_t pSquareGadgets; *Gadget_t pTextGadget) bool:
    uint x, y;
    *SquareGadget_t pSquareGadget;
    [30] char textBuffer;
    channel output text textBufferChannel;  
    for x from 0 upto dimension - 1 do
        for y from 0 upto dimension - 1 do
            pSquareGadget := getSquareGadget(pSquareGadgets, dimension, x, y);
            if pSquareGadget*.sg_StringInfo.si_Buffer* ~= '\e'
               and (   pSquareGadget*.sg_StringInfo.si_LongInt < 1
                    or pSquareGadget*.sg_StringInfo.si_LongInt > pretend(dimension, int)) then
                open(textBufferChannel, &textBuffer[0]);
                write(textBufferChannel; "Invalid valid '", pSquareGadget*.sg_StringInfo.si_Buffer ,"' at (", x + 1, ",", y + 1, ")");
                close(textBufferChannel);
                setText(pWindow, pTextGadget, &textBuffer[0]);
                return false;
            fi;
        od;
    od;
    true
corp;

proc cleanupAfterSolver(*Window_t pWindow;
                        uint dimension;
                        *SquareGadget_t pSquareGadgets;
                        *Gadget_t pButtonGadget;
                        *Grid_t pGridList;
                        *Counters_t pCounters) void:
    write(out; "\n\(27)[33mFinal statistics:\(27)[0m");
    writeCounters(out, pCounters);
    freeGridList(pGridList);               
    pButtonGadget*.g_Flags := pButtonGadget*.g_Flags >< SELECTED;
    toggleSolveButton(pWindow, pButtonGadget);
    toggleSquareGadgetsEnabled(dimension, pSquareGadgets);
    ClearPointer(pWindow);
corp;

proc eventLoop(*Window_t pWindow; uint sectorDimension; *SquareGadget_t pSquareGadgets; *Gadget_t pButtonGadget, pTextGadget) uint:  
    Menu_t gridMenu;
    MenuItem_t resetMenuItem, sizeMenuItem, size3MenuItem, size4MenuItem;
    IntuiText_t resetMenuItemText, sizeMenuItemText, size3MenuItemText, size4MenuItemText;
    *MenuItem_t pSelectedMenuItem;
    uint dimension;
    *IntuiMessage_t pMessage;
    *Gadget_t pGadget;
    *SquareGadget_t pSquareGadget;
    ulong signals, messageClass@signals, lastWroteCountersTime, menuNumber@pSelectedMenuItem;
    *Grid_t pGridList;
    Counters_t counters;
    gridMenu := Menu_t(nil, 15, 0, 40, 0, MENUENABLED, nil, nil, 0, 0, 0, 0);  
    gridMenu.m_MenuName := "Grid";
    gridMenu.m_FirstItem := &resetMenuItem;
    resetMenuItem := MenuItem_t(nil, 0, 0, 86, 12, ITEMTEXT | ITEMENABLED | HIGHCOMP | COMMSEQ, 0, (nil), (nil), 'R', nil, 0);
    resetMenuItem.mi_NextItem := &sizeMenuItem;
    resetMenuItem.mi_ItemFill.miIt := &resetMenuItemText;
    resetMenuItemText := IntuiText_t(0, 1, 0, 4, 2, nil, nil, nil);
    resetMenuItemText.it_IText := "Reset";
    sizeMenuItem := MenuItem_t(nil, 0, 12, 86, 12, ITEMTEXT | ITEMENABLED, 0, (nil), (nil), ' ', nil, 0);
    sizeMenuItem.mi_ItemFill.miIt := &sizeMenuItemText;
    sizeMenuItem.mi_SubItem := &size3MenuItem;
    sizeMenuItemText := IntuiText_t(0, 1, 0, 4, 2, nil, nil, nil);
    sizeMenuItemText.it_IText := "Size     \(187)";
    size3MenuItem := MenuItem_t(nil, 86, 0, 90, 12, CHECKIT | ITEMTEXT | ITEMENABLED | HIGHCOMP, 0, (nil), (nil), ' ', nil, 0);
    size3MenuItem.mi_NextItem := &size4MenuItem;
    size3MenuItem.mi_ItemFill.miIt := &size3MenuItemText;
    size3MenuItemText := IntuiText_t(0, 1, 0, CHECKWIDTH + 4, 2, nil, nil, nil);
    size3MenuItemText.it_IText := " 9 by 9 ";
    size4MenuItem := MenuItem_t(nil, 86, 12, 90, 12, CHECKIT | CHECKED | ITEMTEXT | ITEMENABLED | HIGHCOMP, 0, (nil), (nil), ' ', nil, 0);
    size4MenuItem.mi_ItemFill.miIt := &size4MenuItemText;
    size4MenuItemText := IntuiText_t(0, 1, 0, CHECKWIDTH + 4, 2, nil, nil, nil);
    size4MenuItemText.it_IText := "16 by 16";
    if sectorDimension = 3 then
        size3MenuItem.mi_Flags := size3MenuItem.mi_Flags | CHECKED;
        size4MenuItem.mi_Flags := size4MenuItem.mi_Flags & ~CHECKED;
    elif sectorDimension = 4 then
        size3MenuItem.mi_Flags := size3MenuItem.mi_Flags & ~CHECKED;
        size4MenuItem.mi_Flags := size4MenuItem.mi_Flags | CHECKED;
    fi;
    SetMenuStrip(pWindow, &gridMenu);
    dimension := sectorDimension * sectorDimension;
    pGridList := nil;
    while not breakSignaled() do
        if pGridList = nil then       
            signals := Wait((1 << pWindow*.w_UserPort*.mp_SigBit) | SIGBREAKF_CTRL_C);
            if signals & SIGBREAKF_CTRL_C ~= 0 then
                freeGridList(pGridList);
                return 0;
            fi;
        fi;
        while
            pMessage := pretend(GetMsg(pWindow*.w_UserPort), *IntuiMessage_t);
            pMessage ~= nil
        do
            messageClass := pMessage*.im_Class;
            menuNumber := pMessage*.im_Code;
            pGadget := pretend(pMessage*.im_IAddress, *Gadget_t);
            ReplyMsg(pretend(pMessage, *Message_t));        
            case messageClass
                incase CLOSEWINDOW:
                    freeGridList(pGridList);
                    return 0;
                incase MENUPICK:
                    while menuNumber ~= MENUNULL do
                        pSelectedMenuItem := ItemAddress(&gridMenu, menuNumber);
                        if pSelectedMenuItem = &resetMenuItem then
                            restorePreviousValues(pWindow, dimension, pSquareGadgets);
                            if pGridList ~= nil then
                                freeGridList(pGridList);
                                pGridList := nil;
                                pButtonGadget*.g_Flags := pButtonGadget*.g_Flags >< SELECTED;
                                toggleSolveButton(pWindow, pButtonGadget);
                                toggleSquareGadgetsEnabled(dimension, pSquareGadgets);
                                ClearPointer(pWindow);
                            fi;
                            setText(pWindow, pTextGadget, nil);
                        elif pSelectedMenuItem = &size3MenuItem and sectorDimension ~= 3 then
                            freeGridList(pGridList);
                            return 3;
                        elif pSelectedMenuItem = &size4MenuItem and sectorDimension ~= 4 then
                            freeGridList(pGridList);
                            return 4;
                        fi;
                        menuNumber := pSelectedMenuItem*.mi_NextSelect;
                    od;
                incase GADGETDOWN:
                    setText(pWindow, pTextGadget, nil);
                incase GADGETUP:
                    if pGridList = nil then
                        if not valuesAreValid(pWindow, dimension, pSquareGadgets, pTextGadget) then
                            DisplayBeep(nil);
                            pGadget*.g_Flags := pGadget*.g_Flags >< SELECTED;
                        else
                            stashCurrentValues(pWindow, dimension, pSquareGadgets);
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
                                setText(pWindow, pTextGadget, "Solving...");
                                if pBusyPointer ~= nil then
                                    SetPointer(pWindow, pBusyPointer, 16, 16, -6, 0);
                                fi;
                            fi;
                        fi;
                    else
                        if counters.c_Solutions = 0 then
                            restorePreviousValues(pWindow, dimension, pSquareGadgets);
                        fi;
                        toggleSquareGadgetsEnabled(dimension, pSquareGadgets);
                        freeGridList(pGridList);
                        pGridList := nil;
                        setText(pWindow, pTextGadget, nil);
                        ClearPointer(pWindow);
                    fi;
                    toggleSolveButton(pWindow, pGadget);
            esac;
        od;
        if pGridList ~= nil then
            if GetCurrentTime() - lastWroteCountersTime >= 10 then
                writeCounters(out, &counters);
                lastWroteCountersTime := GetCurrentTime();
            fi;
            pGridList := advanceSolving(pGridList, &counters);                    
            if pGridList = nil then                   
                if counters.c_Solutions = 1 then
                    if counters.c_GridsLost = 0 then
                        setText(pWindow, pTextGadget, "Solution is unique");
                    else
                        setText(pWindow, pTextGadget, "Failed to check for uniqueness");
                    fi;
                else                 
                    restorePreviousValues(pWindow, dimension, pSquareGadgets);
                    if counters.c_GridsLost = 0 then
                        setText(pWindow, pTextGadget, "Puzzle has no solutions");
                    else
                        setText(pWindow, pTextGadget, "Failed to find solution");
                    fi;
                fi;
                cleanupAfterSolver(pWindow, dimension, pSquareGadgets, pButtonGadget, pGridList, &counters);              
            elif isComplete(pGridList) then
                updateSquareGadgetValues(pWindow, pSquareGadgets, pGridList);
                pGridList := freeFrontGrid(pGridList);
                counters.c_Solutions := counters.c_Solutions + 1;
                if counters.c_Solutions > 1 then
                    setText(pWindow, pTextGadget, "Solution is not unique");
                    cleanupAfterSolver(pWindow, dimension, pSquareGadgets, pButtonGadget, pGridList, &counters);
                    pGridList := nil;
                elif pGridList ~= nil then
                    setText(pWindow, pTextGadget, "Checking solution is unique...");
                elif counters.c_GridsLost = 0 then
                    setText(pWindow, pTextGadget, "Solution is unique");
                    cleanupAfterSolver(pWindow, dimension, pSquareGadgets, pButtonGadget, pGridList, &counters);
                else
                    setText(pWindow, pTextGadget, "Failed to check for uniqueness");
                    cleanupAfterSolver(pWindow, dimension, pSquareGadgets, pButtonGadget, pGridList, &counters);
                fi;
            elif counters.c_Solutions = 0 then
                updateSquareGadgetValues(pWindow, pSquareGadgets, pGridList);
            fi;
        fi;
    od;
    freeGridList(pGridList);
    0
corp;

proc createWindow(uint sectorDimension) uint:
    uint dimension;
    *SquareGadget_t pSquareGadgets;
    NewWindow_t newWindow;
    Gadget_t buttonGadget, textGadget;
    Border_t buttonBorderA, buttonBorderB;
    [6] int buttonBorderAXY, buttonBorderBXY;
    IntuiText_t buttonText;
    StringInfo_t textStringInfo;
    [30] char textBuffer;
    *Window_t pWindow;
    dimension := sectorDimension * sectorDimension;
    pSquareGadgets := createSquareGadgets(dimension, 6, 13);
    if pSquareGadgets = nil then
        writeln(out; "Failed to create gadgets");
        DisplayBeep(nil);
        return 0;
    fi;
    buttonGadget := Gadget_t(nil, /* g_NextGadget */
                             4, /* g_LeftEdge */
                             0, /* g_TopEdge */
                             0, /* g_Width */
                             15,   /* g_Height */
                             GADGHCOMP, /* g_Flags */
                             RELVERIFY | TOGGLESELECT, /* g_Activation */
                             BOOLGADGET, /* g_GadgetType */
                             (nil), /* g_GadgetRender */
                             (nil), /* g_SelectRender */
                             nil, /* g_GadgetText */
                             0, /* g_MutualExclude */
                             (nil), /* g_SpecialInfo */
                             0, /* g_GadgetID */
                             nil); /* g_UserData */
    buttonGadget.g_TopEdge := 12 * (dimension - 1) + 32;
    buttonGadget.g_Width := 32 * (dimension - 1) + 31;
    buttonGadget.g_NextGadget := &textGadget;
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
    textGadget := Gadget_t(nil, /* g_NextGadget */
                           4, /* g_LeftEdge */
                           0, /* g_TopEdge */
                           24, /* g_Width */
                           5, /* g_Height */
                           0, /* g_Flags */
                           0, /* g_Activation */
                           STRGADGET, /* g_GadgetType */
                           (nil), /* g_GadgetRender */
                           (nil), /* g_SelectRender */
                           nil, /* g_GadgetText */
                           0, /* g_MutualExclude */
                           (nil), /* g_SpecialInfo */
                           0, /* g_GadgetID */
                           nil); /* g_UserData */
    textGadget.g_NextGadget := &pSquareGadgets*.sg_Gadget;
    textGadget.g_TopEdge := 12 * (dimension - 1) + 23;
    textGadget.g_Width := 32 * (dimension - 1) + 31;
    textGadget.g_SpecialInfo.gStr := &textStringInfo;
    textStringInfo := StringInfo_t(nil, nil, 0, 0, 0, 0, 0, 0, 0, 0, nil, 0, nil);
    textStringInfo.si_MaxChars := 31;
    textStringInfo.si_Buffer := &textBuffer[0];
    BlockFill(&textBuffer[0], 30, pretend('\e', byte));
    CharsCopyN(&textBuffer[0], "Edit puzzle, then click Solve", textStringInfo.si_MaxChars - 1);
    newWindow := NewWindow_t(50,
                             15,
                             0,
                             0,
                             FREEPEN,
                             FREEPEN,
                             CLOSEWINDOW | MENUPICK | GADGETUP | GADGETDOWN,
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
        freeSquareGadgets(pSquareGadgets, dimension);
        return 0;
    fi;
    SetWindowTitles(pWindow, pretend(-1, *char), "Sudoku solver");
    buttonGadget.g_Flags := buttonGadget.g_Flags | SELECTED;
    RefreshGList(&buttonGadget, pWindow, nil, 1);
    textGadget.g_Flags := textGadget.g_Flags | GADGDISABLED;
    drawSectorLines(pWindow, sectorDimension);
    sectorDimension := eventLoop(pWindow, sectorDimension, pSquareGadgets, &buttonGadget, &textGadget);
    ClearMenuStrip(pWindow);
    CloseWindow(pWindow);
    freeSquareGadgets(pSquareGadgets, dimension);
    sectorDimension
corp;

proc main() void:
    *Process_t pProcess;
    *Message_t pWorkbenchStartup;
    uint sectorDimension;
    squareGadgetBorder := Border_t(-2, -2, 2, 0, 0, 5, nil, nil);
    squareGadgetBorder.b_XY := &squareGadgetBorderXY[0];
    pWorkbenchStartup := nil;
    sectorDimension := 4;
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
                    pBusyPointer := pretend(AllocMem(72, MEMF_CHIP), *uint);
                    if pBusyPointer ~= nil then
                        BlockCopy(pBusyPointer, &BUSY_POINTER[0], 72);
                    fi;
                    while sectorDimension ~= 0 do
                        sectorDimension := createWindow(sectorDimension);
                    od;
                    if pBusyPointer ~= nil then
                        FreeMem(pBusyPointer, 72);
                    fi;
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