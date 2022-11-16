
GEN_IO_INPUT equ 0x8032;

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
        jsr  Input_clearUnderlines;
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
Input_acceptUserHints:
        push r1;
        jsr  Leds_renderGrid;       // for reset
        jsr  Input_clearUnderlines; // for reset
        ld.w r1, #messageInput;
        jsr  Leds_renderThisMessage;
        addi sp, #-4;
        ld.b r1, #4;
        push r1;
        push r1;
        jsr  Input_underline;
        ld.w r3, GEN_IO_INPUT;
    Input_acceptUserHints_loop:
        ld.w r0, GEN_IO_INPUT;
        cmp  r0, r3;
        beq  Input_acceptUserHints_loop;
        btst r3, #0;
        beq  Input_acceptUserHints_down;
        btst r0, #0;
        bne  Input_acceptUserHints_down;
        ld.b r2, (sp+0);
        dec  r2;
        bpl  $+4;
        ld.b r2, #8;
        st.b (sp+0), r2;
        st.w (sp+6), r3;
        jsr  Input_clearUnderlines;
        ld.b r1, (sp+2);
        jsr  Input_underline;
        ld.w r3, (sp+6);
        ld.w r0, GEN_IO_INPUT;
    Input_acceptUserHints_down:
        btst r3, #1;
        beq  Input_acceptUserHints_left;
        btst r0, #1;
        bne  Input_acceptUserHints_left;
        ld.b r2, (sp+0);
        inc  r2;
        jsr  Input_overflowWrap;
        st.b (sp+0), r2;
        st.w (sp+6), r3;
        jsr  Input_clearUnderlines;
        ld.b r1, (sp+2);
        jsr  Input_underline;
        ld.w r3, (sp+6);
        ld.w r0, GEN_IO_INPUT;        
    Input_acceptUserHints_left:
        btst r3, #2;
        beq  Input_acceptUserHints_right;
        btst r0, #2;
        bne  Input_acceptUserHints_right;
        ld.b r2, (sp+2);
        dec  r2;
        bpl  $+4;
        ld.b r2, #8;
        st.b (sp+2), r2;
        st.w (sp+6), r3;
        jsr  Input_clearUnderlines;
        ld.b r1, (sp+2);
        jsr  Input_underline;
        ld.w r3, (sp+6);
        ld.w r0, GEN_IO_INPUT;
    Input_acceptUserHints_right:
        btst r3, #3;
        beq  Input_acceptUserHints_increment;
        btst r0, #3;
        bne  Input_acceptUserHints_increment;
        ld.b r2, (sp+2);
        inc  r2;
        jsr  Input_overflowWrap;
        st.b (sp+2), r2;
        st.w (sp+6), r3;
        jsr  Input_clearUnderlines;
        ld.b r1, (sp+2);
        jsr  Input_underline;
        ld.w r3, (sp+6);
        ld.w r0, GEN_IO_INPUT;
    Input_acceptUserHints_increment:
        ld.w r1, #0b100110000;
        move r2, r3;
        and  r2, r1;
        cmp  r2, r1;
        bne  Input_acceptUserHints_decrement;
        move r2, r0;
        and  r2, r1;
        cmp  r2, r1;
        beq  Input_acceptUserHints_decrement;
        ld.b r1, #1;
        st.w (sp+4), r1;
        ld.w r1, (sp+8);
        st.w (sp+6), r3;
        jsr  Input_deltaValueAt;
        ld.w r3, (sp+6);
        ld.w r0, GEN_IO_INPUT;
    Input_acceptUserHints_decrement:
        ld.w r1, #0b1011000000;
        move r2, r3;
        and  r2, r1;
        cmp  r2, r1;
        bne  Input_acceptUserHints_predefined;
        move r2, r0;
        and  r2, r1;
        cmp  r2, r1;
        beq  Input_acceptUserHints_predefined;
        ld.w r1, #-1;
        st.w (sp+4), r1;
        ld.w r1, (sp+8);
        st.w (sp+6), r3;
        jsr  Input_deltaValueAt;
        ld.w r3, (sp+6);
        ld.w r0, GEN_IO_INPUT;
    Input_acceptUserHints_predefined:
        ld.w r1, #0b1100000000;
        and  r1, r0;
        bne  Input_acceptUserHints_go;
        ld.w r1, (sp+8);
        jsr  Input_initialisePredefined;
        jmp  Input_acceptUserHints_return;        
    Input_acceptUserHints_go:
        move r3, r0;
        ld.w r1, #0b110000000000;
        and  r0, r1;
        beq  Input_acceptUserHints_return;
        jmp  Input_acceptUserHints_loop;
    Input_acceptUserHints_return:
        ld.w r1, #messageSolving;       
        jsr  Leds_renderThisMessage;   
        addi sp, #10;
        ret;
        
// r2 - value, input & output
// r1 - clobbered
// r0, r3 - preserved
//
Input_overflowWrap:
        ld.w r1, #-9;
        add  r1, r2;
        bmi  Input_overflowWrap_return;
        move r2, r1;
    Input_overflowWrap_return:
        ret;
  
// function void deltaValueAt(Array grid, int delta, int x, int y)
//
Input_deltaValueAt:
        ld.b r2, (sp+2);
        move r3, r2;
        add  r3, r3;
        add  r3, r3;
        add  r3, r3;
        add  r3, r2;
        ld.b r2, (sp+4);
        add  r3, r2;
        add  r3, r3;
        add  r3, r3;
        add  r3, r1;
        addq r3, #2;
        ld.b r0, (r3);
        ld.w r2, (sp+6);
        add  r0, r2;
        bpl  Input_deltaValueAt_skip_negative_wrap;
        ld.b r2, #10;
        add  r0, r2;
    Input_deltaValueAt_skip_negative_wrap:
        ld.w r2, #-10;
        add  r2, r0;
        bmi  Input_deltaValueAt_skip_positive_wrap;
        move r0, r2;
    Input_deltaValueAt_skip_positive_wrap:
        st.b (r3), r0;
        jmp  Leds_renderGridLine;
        
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
    
// function void initialisePredefined(Array grid)
//    
Input_initialisePredefined:
    push r1;
    jsr  Grid_initialise;
    pop  r3;
    ld.b r0, #7 * 4 + 2;
    add  r3, r0;
    ld.b r1, #1;
    st.b (r3), r1;
    addq r3, #2;
    addq r3, #2;
    ld.b r1, #6;
    st.b (r3), r1;
    ld.b r0, #4 * 4;
    add  r3, r0;
    inc  r1;
    st.b (r3), r1;
    ld.b r0, #2 * 4;
    add  r3, r0;
    inc  r1;
    st.b (r3), r1;
    ld.b r0, #11 * 4;
    add  r3, r0;
    ld.b r1, #5;
    st.b (r3), r1;
    ld.b r0, #2 * 4;
    add  r3, r0;
    st.b (r3), r1;    
    add  r3, r0;
    ld.b r1, #1;
    st.b (r3), r1;    
    addq r3, #2;
    addq r3, #2;
    inc  r1;
    st.b (r3), r1;    
    ld.b r0, #6 * 4;
    add  r3, r0;
    inc  r1;
    st.b (r3), r1;   
    add  r3, r0;
    ld.b r1, #8;
    st.b (r3), r1;    
    ld.b r0, #3 * 4;
    add  r3, r0;
    ld.b r1, #6;
    st.b (r3), r1;    
    ld.b r0, #10 * 4;
    add  r3, r0;
    ld.b r1, #4;
    st.b (r3), r1;    
    ld.b r0, #5 * 4;
    add  r3, r0;
    ld.b r1, #2;
    st.b (r3), r1;    
    ld.b r0, #7 * 4;
    add  r3, r0;
    ld.b r1, #5;
    st.b (r3), r1;    
    addq r3, #2;
    addq r3, #2;
    ld.b r1, #3;
    st.b (r3), r1;    
    ld.b r0, #5 * 4;
    add  r3, r0;
    ld.b r1, #8;
    st.b (r3), r1;    
    ld.b r0, #3 * 4;
    add  r3, r0;
    ld.b r1, #1;
    st.b (r3), r1;    
    ret;