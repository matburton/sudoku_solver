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

type square_text_buffer_t = [6] char;
type border_six_t = [6] int;

type SquareGadget_t = struct {
    Gadget_t sg_Gadget;
    StringInfo_t sg_StringInfo;
    [3] char sg_TextBuffer;
    [3] char sg_UndoBuffer;
};

[10] int squareGadgetBorderXY = (0,  0,  0,  10, 30, 10, 30, 0, 0, 0);

Border_t squareGadgetBorder;

extern _d_IO_initialize() void;

channel output text out;

proc devNullChar(char c) void:
corp;

proc createSquareGadget(int x, y) *Gadget_t:
    *SquareGadget_t pSquareGadget;
    pSquareGadget := new(SquareGadget_t);
    if pSquareGadget = nil then
        return nil;
    fi;
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
    pSquareGadget*.sg_Gadget.g_LeftEdge := x;
    pSquareGadget*.sg_Gadget.g_TopEdge := y;
    pSquareGadget*.sg_Gadget.g_GadgetRender.gBorder := &squareGadgetBorder;
    pSquareGadget*.sg_Gadget.g_SpecialInfo.gStr := &pSquareGadget*.sg_StringInfo;
    pSquareGadget*.sg_Gadget.g_UserData := pretend(pSquareGadget, arbptr);
    pSquareGadget*.sg_StringInfo := StringInfo_t(nil, nil, 0, 3, 0, 0, 0, 0, 0, 0, nil, 0, nil);
    pSquareGadget*.sg_StringInfo.si_Buffer := &pSquareGadget*.sg_TextBuffer[0];
    pSquareGadget*.sg_StringInfo.si_UndoBuffer := &pSquareGadget*.sg_UndoBuffer[0];
    pSquareGadget*.sg_TextBuffer[0] := '\e';
    &pSquareGadget*.sg_Gadget
corp;

proc freeSquareGadget(*Gadget_t pGadget) void:
    free(pretend(pGadget*.g_UserData, *SquareGadget_t));
corp;

proc eventLoop(*Window_t pWindow; *StringInfo_t pStringInfo; *Gadget_t pGadget, pGadgetB) void:
    *IntuiMessage_t pMessage;
    ulong signals, messageClass;
    bool enabled;
    enabled := true;
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
                    writeln(out; "No menus yet");
                    writeln(out; "Value: ", pStringInfo*.si_LongInt);
                incase GADGETUP:
                    /* On refresh enabale, refresh then disable again */
                    if enabled then
                        writeln(out; "Disabling gadget");
                        pGadgetB*.g_GadgetText*.it_IText := "Cancel";
                        pGadget*.g_Flags := pGadget*.g_Flags | GADGDISABLED;
                    else
                        writeln(out; "Enabling gadget");
                        pGadgetB*.g_GadgetText*.it_IText := "Solve";
                        pGadget*.g_Flags := pGadget*.g_Flags & ~GADGDISABLED;
                    fi;
                    enabled := not enabled;
                    RectFill(pWindow*.w_RPort, 4, 23, 103, 37);
                    RefreshGList(pGadgetB, pWindow, nil, 1);
                    RefreshGList(pGadgetB, pWindow, nil, 1);
            esac;
        od;
    od;
corp;

proc main() void:
    NewWindow_t newWindow;
    *Gadget_t pGadget, pGadgetB;
    Gadget_t gadgetB;
    Border_t borderB, borderC;
    border_six_t borderCoordinatesB, borderCoordinatesC;
    StringInfo_t stringInfo;
    *Window_t pWindow;
    IntuiText_t intuiText;
    
    squareGadgetBorder := Border_t(-2, -2, 2, 0, 0, 5, nil, nil);
    squareGadgetBorder.b_XY := &squareGadgetBorderXY[0];
    
    borderCoordinatesB :=  border_six_t(0,  14, 0,  0,  99, 0);
    borderCoordinatesC := border_six_t(99, 0,  99, 14, 0,  14);
    
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
        
        writeln(out; "Hello world");
        
        pGadget := createSquareGadget(6, 13);
        
        /* TODO: Check if pSquareGadget is null or allocate all at once somehow */
        
        CharsCopy(pretend(pGadget*.g_SpecialInfo.gStr*.si_Buffer, *char), "9");
        pGadget*.g_SpecialInfo.gStr*.si_LongInt := 9;
        
        pGadgetB := createSquareGadget(pGadget*.g_LeftEdge + pGadget*.g_Width + 8, pGadget*.g_TopEdge);
        
        pGadget*.g_NextGadget := pGadgetB;
        pGadgetB*.g_NextGadget := &gadgetB;        
        
        gadgetB := Gadget_t(nil, /* g_NextGadget */
                            4,   /* g_LeftEdge */
                            23,  /* g_TopEdge */
                            100,  /* g_Width */
                            15,   /* g_Height */
                            GADGHCOMP,   /* g_Flags */
                            RELVERIFY, /* g_Activation */
                            BOOLGADGET, /* g_GadgetType */
                            (nil), /* g_GadgetRender */
                            (nil), /* g_SelectRender */
                            nil,   /* g_GadgetText */
                            0,     /* g_MutualExclude */
                            (nil), /* g_SpecialInfo */
                            0,     /* g_GadgetID */
                            nil);  /* g_UserData */
        borderB := Border_t(0, 0, 2, 0, 0, 3, nil, nil);
        borderB.b_XY := &borderCoordinatesB[0];
        borderB.b_NextBorder := &borderC;
        borderC := Border_t(0, 0, 1, 0, 0, 3, nil, nil);
        borderC.b_XY := &borderCoordinatesC[0];
        gadgetB.g_GadgetRender.gBorder := &borderB;
        intuiText := IntuiText_t(1, 0, 0, 30, 4, nil, nil, nil);
        intuiText.it_IText := "Solve";
        gadgetB.g_GadgetText := &intuiText;
        newWindow := NewWindow_t(100,
                                 50,
                                 200,
                                 100,
                                 FREEPEN,
                                 FREEPEN,
                                 CLOSEWINDOW | MENUPICK | GADGETUP,
                                 SMART_REFRESH | ACTIVATE | WINDOWDEPTH | WINDOWCLOSE | WINDOWDRAG | NOCAREREFRESH,
                                 nil,
                                 nil,
                                 nil,
                                 nil,
                                 nil,
                                 40,
                                 33,
                                 320,
                                 200,
                                 WBENCHSCREEN);
        newWindow.nw_FirstGadget := pGadget;
        newWindow.nw_Title := "Sudoku solver";
        pWindow := OpenWindow(&newWindow);
        if pWindow ~= nil then
            gadgetB.g_Flags := gadgetB.g_Flags | SELECTED;
            RefreshGadgets(pGadget, pWindow, nil);
            eventLoop(pWindow, pGadget*.g_SpecialInfo.gStr, pGadget, &gadgetB);
            CloseWindow(pWindow);
        fi;
        freeSquareGadget(pGadgetB);
        freeSquareGadget(pGadget);
        CloseGraphicsLibrary();
    fi;
    CloseIntuitionLibrary();
    fi;
    CloseDosLibrary();
    fi;
    CloseExecLibrary();
    fi;
    /* TODO: real menus, grid lines */
corp;