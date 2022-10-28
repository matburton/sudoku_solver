
// function void removePossibilityAt(Array grid, int value, int x, int y)
//
Solver_removePossibilityAt:
        ld.b r3, (sp+6);
        ld.b r0, (sp+4);
        ld.b r2, (sp+2);
        addi sp, #-2;
        push r1;
        push r3;
        move r3, r2;
        add  r3, r3;
        add  r3, r3;
        add  r3, r3;
        add  r3, r2;
        add  r3, r0;
        add  r3, r3;
        add  r3, r3;
        add  r3, r1;
        ld.w r0, (r3);
        ld.w r2, (sp+0);
        bclr r0, r2;
        bne  Grid_removeSquarePossibility_continue;
        addi sp, #6;
        ret;
    Grid_removeSquarePossibility_continue:
        move r2, r1;
        st.w (r3), r0;
        addq r3, #2;
        inc  r3;
        ld.b r1, (r3);
        dec  r1;
        beq  Grid_removeSquarePossibility_impossible;
        st.b (r3), r1;
        dec  r1;
        beq  Grid_removeSquarePossibility_value;
        addi sp, #6;
        ret;
    Grid_removeSquarePossibility_impossible:
        dec  r3;
        st.w (r3), r1;
        ld.w r0, #GRID_IMPOSSIBLE_FLAG_OFFSET;
        add  r2, r0;
        ld.b r0, #-1;
        st.b (r2), r0;
        dec  r2;
        ld.b r0, (r2);
        inc  r0;
        st.b (r2), r0;
        addi sp, #6;
        ret;
    Grid_removeSquarePossibility_value:
        ld.w r1, #GRID_INCOMPLETE_SQUARE_COUNT_OFFSET;
        add  r2, r1;
        ld.b r1, (r2);
        dec  r1;
        st.b (r2), r1;
        move r1, r0;
        jsr  Grid_calculateValue;
        dec  r3;
        st.b (r3), r1;
        addi sp, #2;
        st.b (sp+2), r1;
        ld.w r1, (sp+0);
        ld.b r0, (sp+6);
        push r0;
        jsr  Leds_renderGridLine;
        addi sp, #2;
        pop  r1;
        ld.b r2, (sp+6);
        ld.b r3, (sp+4);
        push r2;
        push r3;
        jsr  Solver_removePossibilitiesRelatedTo;
        addi sp, #6;
        ret;
        
// function void setValueAt(Array grid, int value, int x, int y)
//
Solver_setValueAt:
        push r1;
        ld.b r0, (sp+8);
        push r0;
        ld.b r0, (sp+8);
        push r0;
        ld.b r0, (sp+8);
        push r0;
        jsr  Grid_setSquareValue;
        ld.w r1, (sp+6);
        jsr  Leds_renderGridLine;
        ld.w r1, (sp+6);
        jsr  Solver_removePossibilitiesRelatedTo;
        addi sp, #8;
        ret;
        
// Returns zero if no value could be deduced
//
// function int getDeducedValueAt(Array grid, int x, int y)
//
Solver_getDeducedValueAt:
        nop;
    include "asm/Grid_getSquareOffset.asm";
        add  r3, r1;
        addq r3, #2;
        inc  r3;
        ld.b r0, (r3);
        addq r0, #-2;
        bmi  Solver_getDeducedValueAt_early_zero;
        addq r3, #-2;
        dec  r3;
        ld.w r0, (r3);        
        push r1;
        push r0;                
        addi sp, #-2;
        ld.b r3, (sp+10);
        push r3;
        ld.b r3, (sp+10);
        push r3;
        ld.b r2, #10;
    Solver_getDeducedValueAt_loop:
        dec  r2;
        beq  Solver_getDeducedValueAt_return_zero;
        btst r0, r2;
        beq  Solver_getDeducedValueAt_loop;
        st.b (sp+4), r2;       
        jsr  Grid_mustBeValue;
        test r1;
        bne  Solver_getDeducedValueAt_return_value;
        ld.b r2, (sp+4);
        ld.w r0, (sp+6);
        ld.w r1, (sp+8);
        jmp  Solver_getDeducedValueAt_loop;        
    Solver_getDeducedValueAt_return_zero:
        addi sp, #10;
    Solver_getDeducedValueAt_early_zero:
        ld.b r1, #0;
        ret;
    Solver_getDeducedValueAt_return_value:
        ld.b r1, (sp+4);
        addi sp, #10;
        ret;
        
// function void refineGrid(Array grid)
//
Solver_refineGrid:
        push r1;
        ld.b r0, #0;
        move r2, r0;
        push r0;
        push r2;
    Solver_refineGrid_loop:
        push r0;
        push r2;
        jsr  Solver_getDeducedValueAt;
        pop  r2;
        pop  r0;
        test r1;
        beq  Solver_refineGrid_no_value;
        push r1;
        ld.w r1, (sp+6);
        push r0;
        push r2;        
        jsr  Solver_setValueAt;
        pop  r2;
        pop  r0;
        addi sp, #2;
        ld.w r1, (sp+4);
        ld.w r3, #GRID_INCOMPLETE_SQUARE_COUNT_OFFSET;
        add  r3, r1;
        ld.b r1, (r3++);
        beq  Solver_refineGrid_return;
        ld.b r1, (r3);
        bne  Solver_refineGrid_return;
        st.b (sp+2), r0;
        st.b (sp+0), r2;        
    Solver_refineGrid_no_value:
        ld.w r1, (sp+4);
        btst r0, #3;
        beq  Solver_refineGrid_no_reset_x;
        btst r2, #3;
        beq  Solver_refineGrid_no_reset_y;
        ld.b r2, #-1;
    Solver_refineGrid_no_reset_y:
        inc  r2;
        ld.b r0, #-1;
    Solver_refineGrid_no_reset_x:
        inc  r0;
        ld.b r3, (sp+2);
        cmp  r0, r3;
        bne  Solver_refineGrid_loop;
        ld.b r3, (sp+0);
        cmp  r2, r3;
        bne  Solver_refineGrid_loop;
    Solver_refineGrid_return:
        addi sp, #6;
        ret;