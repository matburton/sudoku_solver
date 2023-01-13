
// Assumes value != 0
// Assumes previous rendered value was 0
//
// function void renderValueAt(int value, int x, int y)
//
Leds_v2_renderValueAt:
        ld.b r0, gridRenderDisableCount;
        bne  Leds_v2_renderValueAt_return;
        ld.w r2, #ledStartLookupFromY;
        ld.b r0, (sp+2);
        add  r2, r0;
        add  r2, r0;
        ld.w r0, (r2);
        move r2, r0;
        ld.w r3, #xToLedOffset;
        ld.b r0, (sp+4);
        add  r3, r0;
        ld.b r0, (r3);
        add  r2, r0;     // r2 - LED pointer @ top
        ld.w r3, #xToDigitLookupOffset;
        ld.b r0, (sp+4);
        add  r3, r0;
        add  r3, r0;
        ld.w r0, (r3);
        ld.w r3, #digitLookup;
        add  r3, r0;     // r3 - Lookup pointer @ x
        dec  r1;
        add  r1, r1;
        add  r3, r1;
        add  r1, r1;
        add  r1, r1;
        add  r3, r1;
    include "asm/Leds_v2_renderValueAt_renderLine.asm";
        addq r2, #2;
    include "asm/Leds_v2_renderValueAt_renderLine.asm";
        addq r2, #2;
    include "asm/Leds_v2_renderValueAt_renderLine.asm";
        addq r2, #2;
    include "asm/Leds_v2_renderValueAt_renderLine.asm";
        addq r2, #2;
    include "asm/Leds_v2_renderValueAt_renderLine.asm";
    Leds_v2_renderValueAt_return:
        ret;