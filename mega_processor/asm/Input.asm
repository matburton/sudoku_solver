
// function void copyUserHintsToGrid(Array grid)
//
Input_copyUserHintsToGrid:
        move r0, sp;
        ld.w r2, #GRID_SIZE;
        sub  r0, r2;
        move sp, r0;
        push r0;
        push r1;
        jsr  Grid_initialise;
        ld.w r1, (sp+2);
        jsr  Grid_initialise;
        ld.w r1, (sp+2);
        jsr  Input_acceptUserHints;
        jsr  Leds_addGridRenderDisable;        
        ld.w r0, #SQUARE_COUNT * SQUARE_SIZE + 2;
        ld.w r3, (sp+2);
        add  r3, r0;
        ld.b r2, #9;        
    Input_copyUserHintsToGrid_y_loop:
        dec  r2;
        bmi  Input_copyUserHintsToGrid_exit_loop;
        ld.b r1, #9;        
    Input_copyUserHintsToGrid_x_loop:
        dec  r1;
        bmi Input_copyUserHintsToGrid_y_loop;
        addq r3, #-2;
        addq r3, #-2;
        ld.b r0, (r3);        
        beq  Input_copyUserHintsToGrid_x_loop;        
        push r3;
        push r0;
        push r1;
        push r2;
        ld.w r1, (sp+8);
        jsr  Solver_setHintAt;
        pop  r2;
        pop  r1;
        addi sp, #2;
        pop  r3;
        jmp  Input_copyUserHintsToGrid_x_loop;
    Input_copyUserHintsToGrid_exit_loop:
        jsr  Leds_undoGridRenderDisable;
        ld.w r1, (sp+0);
        jsr  Leds_renderGrid;
        move r0, sp;
        ld.w r2, #GRID_SIZE + 4;
        add  r0, r2;
        move sp, r0;  
        ret;

// function void acceptUserHints(Array grid)
//
Input_acceptUserHints: // TODO: Implement for real
        move r3, r1;
        addq r3, #2;
        ld.b r0, #3;
        st.b (r3++), r0;
        addq r0, #2;
        addq r3, #2;
        addq r3, #1;
        st.b (r3), r0;
        ret;
        
// function void underline(int x, int y)
//
Input_underline:
        ld.w r2, #ledStartLookupFromY;
        ld.b r0, (sp+2);
        add  r0, r0;
        add  r2, r0;
        ld.w r0, (r2);
        move r2, r0;
        addq r2, #-2;
        addq r2, #-2;
        add  r1, r1;
        add  r1, r1;
        ld.w r3, #highlightLookupFromX;
        add  r3, r1;
        ld.w r0, (r3++);
        ld.w r1, (r2);
        or   r0, r1;
        st.w (r2++), r0;
        ld.w r0, (r3);
        ld.w r1, (r2);
        or   r0, r1;
        st.w (r2++), r0;
        addq r3, #-2;
        ld.b r1, #5 * 4;
        add  r2, r1;
        ld.w r0, (r3++);
        ld.w r1, (r2);
        or   r0, r1;
        st.w (r2++), r0;
        ld.w r0, (r3);
        ld.w r1, (r2);
        or   r0, r1;
        st.w (r2), r0;
        ret;
        
// function void clearUnderlines()
//
Input_clearUnderlines:
        ld.w r1, #0b0000010000000000;
        ld.w r2, #0b0000000000100000;
        ld.w r3, #LED_START;
    include "asm/Input_clearLine.asm";
        ld.w r3, #LED_START + (6  * 4);
    include "asm/Input_clearLine.asm";
        ld.w r3, #LED_START + (12 * 4);
    include "asm/Input_clearLine.asm";
        ld.w r3, #LED_START + (20 * 4);
    include "asm/Input_clearLine.asm";
        ld.w r3, #LED_START + (26 * 4);
    include "asm/Input_clearLine.asm";
        ld.w r3, #LED_START + (32 * 4);
    include "asm/Input_clearLine.asm";
        ld.w r3, #LED_START + (40 * 4);
    include "asm/Input_clearLine.asm";
        ld.w r3, #LED_START + (46 * 4);
    include "asm/Input_clearLine.asm";
        ld.w r3, #LED_START + (52 * 4);
    include "asm/Input_clearLine.asm";
        ret;