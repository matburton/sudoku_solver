
// function void renderValueAt(int y, int value, int x)
//
Leds_v2_renderValueAt:       
        ld.w r2, #ledStartLookupFromY;
        add  r2, r1;
        add  r2, r1;
        ld.w r0, (r2);
        move r2, r0;
        ld.w r3, #xToLedOffset;
        ld.b r0, (sp+2);
        add  r3, r0;
        ld.b r1, (r3);
        add  r2, r1;     // r2 - LED pointer @ bottom
        ld.w r3, #xToDigitLookupOffset;
        add  r3, r0;
        add  r3, r0;
        ld.w r0, (r3);
        ld.w r3, #digitLookup;
        add  r3, r0;     // r3 - Lookup pointer @ x
        ld.w r1, (r3++); // r1 - Square mask
    include "asm/Leds_v2_renderValueAt_maskLine.asm";
    include "asm/Leds_v2_renderValueAt_maskLine.asm";
    include "asm/Leds_v2_renderValueAt_maskLine.asm";
    include "asm/Leds_v2_renderValueAt_maskLine.asm";
        ld.w r0, (r2);
        and  r0, r1;
        st.w (r2), r0;   // r2 - LED pointer @ top       
        ld.b r0, (sp+4);
        beq  Leds_v2_renderValueAt_return;
        dec  r0;
        add  r0, r0;
        add  r3, r0;
        add  r0, r0;
        add  r0, r0;      
        add  r3, r0;
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