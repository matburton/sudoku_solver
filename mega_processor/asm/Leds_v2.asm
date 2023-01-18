
// Assumes value != 0
// Assumes previous rendered value was 0
//
// function void renderValueAt(int value, int x, int y)
//
Leds_v2_renderValueAt:
        ld.b r0, gridRenderDisableCount;
        bne  Leds_v2_renderValueAt_return;
Leds_v2_renderValueAt_skip_precondition:
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
        
// function void renderGrid(Array grid)
//
Leds_v2_renderGrid:
        ld.b r0, gridRenderDisableCount;
        bne  Leds_v2_renderValueAt_return;
        ld.w r0, #SQUARE_COUNT * SQUARE_SIZE + 2;
        add  r1, r0;
        push r1;
        ld.w r2, #LED_START + 4;
        ld.w r3, #startupLeds + 4;
        ld.b r1, #114 / 6;
    Leds_v2_renderGrid_wipe_loop:
        ld.w r0, (r3++);
        st.w (r2++), r0;
        ld.w r0, (r3++);
        st.w (r2++), r0;
        ld.w r0, (r3++);
        st.w (r2++), r0;
        ld.w r0, (r3++);
        st.w (r2++), r0;
        ld.w r0, (r3++);
        st.w (r2++), r0;
        ld.w r0, (r3++);
        st.w (r2++), r0;
        dec  r1;
        bne  Leds_v2_renderGrid_wipe_loop;
        pop  r2;     // square value ptr
        ld.b r0, #8; // y
        ld.b r3, #9; // x
    Leds_v2_renderGrid_square_loop:
        addq r2, #-2;
        addq r2, #-2;
        dec  r3;
        bpl  Leds_v2_renderGrid_square_loop_same_y;
        dec  r0;
        bmi  Leds_v2_renderGrid_return;
        ld.b r3, #8;
    Leds_v2_renderGrid_square_loop_same_y:
        ld.b r1, (r2);
        beq  Leds_v2_renderGrid_square_loop;
        push r2;
        push r3;
        push r0;
        jsr  Leds_v2_renderValueAt_skip_precondition;
        pop  r0;
        pop  r3;
        pop  r2;
        jmp  Leds_v2_renderGrid_square_loop;
    Leds_v2_renderGrid_return:
        ret;