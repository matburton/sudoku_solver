#drinc:exec/miscellaneous.g
#drinc:exec/ports.g
#drinc:exec/tasks.g
#drinc:libraries/dos.g
#drinc:intuition/border.g
#drinc:intuition/intuiMessage.g
#drinc:intuition/intuiText.g
#drinc:intuition/gadget.g
#drinc:intuition/miscellaneous.g
#drinc:intuition/screen.g
#drinc:intuition/window.g

Handle_t stdOutFileHandle;
channel output text out;

extern GetPars(*ulong pParamCount; **char ppParams) void;

proc stdOutChar(char c) void:
    ignore(Write(stdOutFileHandle, &c, 1));
corp;

proc devNullChar(char c) void:
corp;

proc eventLoop(*Window_t pWindow; *StringInfo_t pStringInfo; *Gadget_t pGadgetC) void:
    *IntuiMessage_t pMessage;
    ulong signals;
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
            case pMessage*.im_Class
                incase CLOSEWINDOW:
                    return;
                incase MENUPICK:
                    writeln(out; "No menus yet");
                    writeln(out; "Value: ", pStringInfo*.si_LongInt);
                incase GADGETUP:
                    if enabled then
                         writeln(out; "Added disabling gadget");
                        ignore(AddGadget(pWindow, pGadgetC, 0));
                    else
                        writeln(out; "Removing disabling gadget");
                        ignore(RemoveGadget(pWindow, pGadgetC));
                    fi;
                    enabled := not enabled;
            esac;
            ReplyMsg(pretend(pMessage, *Message_t)); /* TODO: Reply early */
        od;
    od;
corp;

proc main() void:
    NewWindow_t newWindow;
    Gadget_t gadget, gadgetB, gadgetC;
    Border_t border, borderB, borderC;
    [10] int borderCoordinates, borderCoordinatesB, borderCoordinatesC;
    StringInfo_t stringInfo;
    [3] char stringBuffer, undoBuffer;
    *Window_t pWindow;
    IntuiText_t intuiText;
    Handle_t handle;
    ulong paramCount;
    *char pParams;

    stringBuffer[0] := '\e';
    
    borderCoordinates[0] := 0;
    borderCoordinates[1] := 0;
    borderCoordinates[2] := 0;
    borderCoordinates[3] := 10;   
    borderCoordinates[4] := 30;
    borderCoordinates[5] := 10;
    borderCoordinates[6] := 30;
    borderCoordinates[7] := 0;    
    borderCoordinates[8] := 0;
    borderCoordinates[9] := 0;

    borderCoordinatesB[0] := 0;
    borderCoordinatesB[1] := 14;
    borderCoordinatesB[2] := 0;
    borderCoordinatesB[3] := 0;   
    borderCoordinatesB[4] := 99;
    borderCoordinatesB[5] := 0;
    
    borderCoordinatesC[0] := 99;
    borderCoordinatesC[1] := 0;
    borderCoordinatesC[2] := 99;    
    borderCoordinatesC[3] := 14;
    borderCoordinatesC[4] := 0;
    borderCoordinatesC[5] := 14;
    
    if OpenExecLibrary(0) ~= nil then
    if OpenDosLibrary(0) ~= nil then
    if OpenIntuitionLibrary(0) ~= nil then

        GetPars(&paramCount, &pParams);
    
        if paramCount = 0 then
            open(out, devNullChar);
        else
            stdOutFileHandle := Output();
            open(out, stdOutChar);
        fi;
        
        writeln(out; "Hello world");

        /*
        handle := Open("speak:opt/r", MODE_NEWFILE);
        ignore(Write(handle, "Finished", 9));
        Close(handle);
        */
    
        stringInfo := StringInfo_t(nil, nil, 0, 3, 0, 0, 0, 0, 0, 0, nil, 0, nil);
        stringInfo.si_Buffer := &stringBuffer[0];
        stringInfo.si_UndoBuffer := &undoBuffer[0];
        border := Border_t(-2, -2, 2, 0, 0, 5, nil, nil);
        border.b_XY := &borderCoordinates[0];
        gadget := Gadget_t(nil, /* g_NextGadget */
                           6,   /* g_LeftEdge */
                           13,  /* g_TopEdge */
                           24,  /* g_Width */
                           5,   /* g_Height */
                           0, /* g_Flags */
                           LONGINT | STRINGCENTER, /* g_Activation */
                           STRGADGET, /* g_GadgetType */
                           (nil), /* g_GadgetRender */
                           (nil), /* g_SelectRender */
                           nil,   /* g_GadgetText */
                           0,     /* g_MutualExclude */
                           (nil), /* g_SpecialInfo */
                           1,     /* g_GadgetID */
                           nil);  /* g_UserData */
        gadget.g_NextGadget := &gadgetB;
        gadget.g_GadgetRender.gBorder := &border;
        gadget.g_SpecialInfo.gStr := &stringInfo;
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
                            2,     /* g_GadgetID */
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
        gadgetC := Gadget_t(nil, /* g_NextGadget */
                            6,   /* g_LeftEdge */
                            13,  /* g_TopEdge */
                            24,  /* g_Width */
                            5,   /* g_Height */
                            GADGDISABLED,   /* g_Flags */
                            0,   /* g_Activation */
                            BOOLGADGET, /* g_GadgetType */
                            (nil), /* g_GadgetRender */
                            (nil), /* g_SelectRender */
                            nil,   /* g_GadgetText */
                            0,     /* g_MutualExclude */
                            (nil), /* g_SpecialInfo */
                            1,     /* g_GadgetID */
                            nil);  /* g_UserData */
        gadgetC.g_NextGadget := &gadget;
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
        newWindow.nw_FirstGadget := &gadget;
        newWindow.nw_Title := "Sudoku solver";
        pWindow := OpenWindow(&newWindow);
        if pWindow ~= nil then
            stringBuffer[0] := '9';
            stringBuffer[1] := '\e';
            gadgetB.g_Flags := gadgetB.g_Flags | SELECTED;
            RefreshGadgets(&gadget, pWindow, nil);
            eventLoop(pWindow, &stringInfo, &gadgetC);
            CloseWindow(pWindow);
        fi;
        CloseIntuitionLibrary();
    fi;
    CloseDosLibrary();
    fi;
    CloseExecLibrary();
    fi;
    /* TODO: real menus, grid lines, command line param to start gui */
corp;