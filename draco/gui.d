#drinc:exec/miscellaneous.g
#drinc:exec/ports.g
#drinc:exec/tasks.g
#drinc:graphics/gfx.g
#drinc:graphics/rastport.g
#drinc:libraries/dos.g
#drinc:intuition/border.g
#drinc:intuition/intuiMessage.g
#drinc:intuition/intuiText.g
#drinc:intuition/gadget.g
#drinc:intuition/miscellaneous.g
#drinc:intuition/screen.g
#drinc:intuition/window.g
#drinc:util.g

type SquareGadget_t = struct {
    Gadget_t sg_Gadget;
    StringInfo_t sg_StringInfo;
    [6] char sg_TextBuffer;
};

[10] int squareGadgetBorderXY = (0,  0,  0,  10, 30, 10, 30, 0, 0, 0);

Border_t squareGadgetBorder;

extern _d_IO_initialize() void;

channel output text out;

proc devNullChar(char c) void:
corp;

/* TODO: Use square gadget editing hook */
/* See: http://amigadev.elowar.com/read/ADCD_2.1/Libraries_Manual_guide/node0596.html */

proc setupSquareGadget(*SquareGadget_t pSquareGadget; int dimension) void:
    pSquareGadget*.sg_Gadget := Gadget_t(nil, /* g_NextGadget */
                                         0, /* g_LeftEdge */
                                         0, /* g_TopEdge */
                                         24, /* g_Width */
                                         5, /* g_Height */
                                         0, /* g_Flags */
                                         LONGINT | STRINGCENTER, /* g_Activation */
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
    pSquareGadget*.sg_StringInfo.si_UndoBuffer := &pSquareGadget*.sg_TextBuffer[0] + 3;
    BlockFill(&pSquareGadget*.sg_TextBuffer[0], 6, pretend('\e', byte));
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

proc eventLoop(*Window_t pWindow) void:
    *IntuiMessage_t pMessage;
    ulong signals, messageClass@signals;  
    while true do
        signals := Wait((1 << pWindow*.w_UserPort*.mp_SigBit) | SIGBREAKF_CTRL_C);
        if signals & SIGBREAKF_CTRL_C ~= 0 then
            return;
        fi;
        while
            pMessage := pretend(GetMsg(pWindow*.w_UserPort), *IntuiMessage_t);
            pMessage ~= nil
        do
            messageClass := pMessage*.im_Class;
            ReplyMsg(pretend(pMessage, *Message_t));        
            case messageClass
                incase CLOSEWINDOW:
                    return;
                incase MENUPICK:
                    writeln(out; "Menu pick");
                incase GADGETUP:
                    writeln(out; "Gadget up");
            esac;
        od;
    od;
corp;

proc createWindow(int dimension) void:
    *SquareGadget_t pSquareGadgets;
    NewWindow_t newWindow;
    *Window_t pWindow;
    pSquareGadgets := createSquareGadgets(dimension, 6, 13);
    if pSquareGadgets = nil then
        writeln(out; "Failed to create gadgets");
        DisplayBeep(nil);
        return;
    fi;
    newWindow := NewWindow_t(50,
                             25,
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
    newWindow.nw_Width := 32 * (dimension - 1) + 39;
    newWindow.nw_Height := 12 * (dimension - 1) + 24;
    /* TODO: Re-add solve button */
    newWindow.nw_FirstGadget := &pSquareGadgets*.sg_Gadget;
    newWindow.nw_Title := "Sudoku solver";
    pWindow := OpenWindow(&newWindow);
    if pWindow = nil then
        writeln(out; "Failed to create window");
        DisplayBeep(nil);
    else
        /* TODO: Draw white lines between sectors */
        eventLoop(pWindow);
        CloseWindow(pWindow); 
    fi;
    freeSquareGadgets(pSquareGadgets, dimension);
corp;

proc main() void:
    squareGadgetBorder := Border_t(-2, -2, 2, 0, 0, 5, nil, nil);
    squareGadgetBorder.b_XY := &squareGadgetBorderXY[0];    
    if OpenExecLibrary(0) ~= nil then
        if OpenDosLibrary(0) ~= nil then
            if OpenIntuitionLibrary(0) ~= nil then
                if OpenGraphicsLibrary(0) ~= nil then
                    _d_IO_initialize();    
                    if Output() = 0 then
                        open(out, devNullChar);
                    else
                        open(out);
                    fi;
                    createWindow(9);
                    CloseGraphicsLibrary();
                fi;
                CloseIntuitionLibrary();
            fi;
            CloseDosLibrary();
        fi;
        CloseExecLibrary();
    fi;
corp;