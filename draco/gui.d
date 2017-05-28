#drinc:exec/ports.g
#drinc:exec/tasks.g
#drinc:libraries/dos.g
#drinc:intuition/border.g
#drinc:intuition/intuiMessage.g
#drinc:intuition/gadget.g
#drinc:intuition/miscellaneous.g
#drinc:intuition/screen.g
#drinc:intuition/window.g

proc eventLoop(*Window_t pWindow) void:
    *IntuiMessage_t pMessage;
    ulong signals;
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
                    writeln("No menus yet");
            esac;
            ReplyMsg(pretend(pMessage, *Message_t));
        od;
    od;
corp;

proc main() void:
    NewWindow_t newWindow;
    Gadget_t gadget;
    Border_t border;
    [10] int borderCoordinates;
    StringInfo_t stringInfo;
    [3] char stringBuffer, undoBuffer;
    *Window_t pWindow;
    stringBuffer[0] := '1';
    stringBuffer[1] := '3';
    stringBuffer[2] := '\e';
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
    if OpenIntuitionLibrary(0) ~= nil then
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
                           0,   /* g_Flags */
                           LONGINT | STRINGCENTER, /* g_Activation */
                           STRGADGET, /* g_GadgetType */
                           (nil), /* g_GadgetRender */
                           (nil), /* g_SelectRender */
                           nil,   /* g_GadgetText */
                           0,     /* g_MutualExclude */
                           (nil), /* g_SpecialInfo */
                           1,     /* g_GadgetID */
                           nil);  /* g_UserData */
        gadget.g_GadgetRender.gBorder := &border;
        gadget.g_SpecialInfo.gStr := &stringInfo;
        newWindow := NewWindow_t(100,
                                 50,
                                 200,
                                 100,
                                 FREEPEN,
                                 FREEPEN,
                                 CLOSEWINDOW | MENUPICK,
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
            eventLoop(pWindow);
            CloseWindow(pWindow);
        fi;
        CloseIntuitionLibrary();
    fi;
corp;