
// function void removePossibilitiesRelatedTo(Array grid, int value, int x, int y)
//
Solver_removePossibilitiesRelatedTo:
        ld.b r0, (sp+6);
        push r0;
        ld.b r0, (sp+6);
        push r0;
        ld.b r0, (sp+6);
        push r0;
        push r1;
        ld.b r0, (sp+6);
        push r0;
        addi sp, #-2;
        ld.b r0, (sp+6);
        push r0;
        ld.b r2, (sp+10);
        beq  Solver_removePossibilitiesRelatedToRow_second;
        dec  r2;
    Solver_removePossibilitiesRelatedToRow_first_loop:
        st.b (sp+2), r2;        
        jsr  Solver_removePossibilityAt;
        ld.w r1, (sp+6);
        ld.b r2, (sp+2);
        dec  r2;
        bpl  Solver_removePossibilitiesRelatedToRow_first_loop;
    Solver_removePossibilitiesRelatedToRow_second:
        ld.b r2, #8;
        ld.b r0, (sp+10);
        cmp  r2, r0;
        beq  Solver_removePossibilitiesRelatedToRow_return;
    Solver_removePossibilitiesRelatedToRow_second_loop:
        st.b (sp+2), r2;        
        jsr  Solver_removePossibilityAt;
        ld.w r1, (sp+6);
        ld.b r2, (sp+2);
        dec  r2;
        ld.b r0, (sp+10);
        cmp  r2, r0;
        bne  Solver_removePossibilitiesRelatedToRow_second_loop;
    Solver_removePossibilitiesRelatedToRow_return:
        addi sp, #8;
        push r1;
        ld.b r0, (sp+6);
        push r0;
        ld.b r0, (sp+6);
        push r0;
        ld.b r2, (sp+6);
        beq  Solver_removePossibilitiesRelatedToColumn_second;
        dec  r2;
    Solver_removePossibilitiesRelatedToColumn_first_loop:
        push r2;       
        jsr  Solver_removePossibilityAt;
        ld.w r1, (sp+6);
        pop  r2;            
        dec  r2;
        bpl  Solver_removePossibilitiesRelatedToColumn_first_loop;
    Solver_removePossibilitiesRelatedToColumn_second:
        ld.b r2, #8;
        ld.b r0, (sp+6);
        cmp  r2, r0;
        beq  Solver_removePossibilitiesRelatedToColumn_return;
    Solver_removePossibilitiesRelatedToColumn_second_loop:
        push r2;      
        jsr  Solver_removePossibilityAt;
        ld.w r1, (sp+6);
        pop  r2;
        dec  r2;
        ld.b r0, (sp+6);
        cmp  r2, r0;
        bne  Solver_removePossibilitiesRelatedToColumn_second_loop;
    Solver_removePossibilitiesRelatedToColumn_return:
        addi sp, #12;
        push r1;
        ld.w r2, #sectorOtherCoordLookupFromCoord;
        ld.b r3, (sp+6);
        add  r3, r3;
        add  r3, r2;
        ld.b r0, (r3++);
        push r0;
        ld.b r1, (r3);
        push r1;
        ld.b r3, (sp+8);
        add  r3, r3;
        add  r3, r2;
        ld.b r0, (r3++);
        push r0;
        ld.b r0, (r3);
        push r0;
        ld.b r2, (sp+16);
        push r2;
        push r1;
        push r0;
        ld.w r1, (sp+14);
        jsr  Solver_removePossibilityAt;
        addi sp, #2;
        ld.b r0, (sp+6);
        push r0;
        ld.w r1, (sp+14);
        jsr  Solver_removePossibilityAt;
        ld.b r0, (sp+12);
        st.b (sp+2), r0;
        ld.w r1, (sp+14);
        jsr  Solver_removePossibilityAt;
        addi sp, #2;
        ld.b r0, (sp+4);
        push r0;
        ld.w r1, (sp+14);
        jsr  Solver_removePossibilityAt;
        addi sp, #16;
        ret;

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
        ld.w r0, #GRID_IMPOSSIBLE_FLAG_OFFSET;
        add  r2, r0;
        ld.b r0, #-1;
        st.b (r2), r0;    
        ld.w r0, refineStackReturn;
        beq  Grid_removeSquarePossibility_return;
        move sp, r0;
        jmp  Solver_solve_refine_return;
    Grid_removeSquarePossibility_value:
        ld.w r1, #GRID_INCOMPLETE_SQUARE_COUNT_OFFSET;
        add  r2, r1;
        ld.b r1, (r2);
        dec  r1;
        st.b (r2), r1;
        move r1, r0;
        ld.b r0, #1;
        clr  r2;
    Grid_calculateValue_loop:
        add  r0, r0;
        inc  r2;
        cmp  r1, r0;
        beq  Grid_calculateValue_return;
        add  r0, r0;
        inc  r2;
        cmp  r1, r0;
        beq  Grid_calculateValue_return;
        add  r0, r0;
        inc  r2;
        cmp  r1, r0;
        bne  Grid_calculateValue_loop;
    Grid_calculateValue_return:
        move r1, r2;
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
    Grid_removeSquarePossibility_return:
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
        ld.w r2, #GRID_INCOMPLETE_SQUARE_COUNT_OFFSET;
        add  r2, r1;
        ld.b r0, (r2);
        dec  r0;
        st.b (r2), r0;
        ld.b r2, (sp+0);
        move r3, r2;
        add  r3, r3;
        add  r3, r3;
        add  r3, r3;
        add  r3, r2;
        ld.b r2, (sp+2);
        add  r3, r2;
        add  r3, r3;
        add  r3, r3;
        add  r3, r1;
        clr  r0;
        ld.b r2, (sp+4);
        bset r0, r2;
        st.w (r3), r0;
        ld.w r0, #0x100;
        or   r0, r2;
        addq r3, #2;
        st.w (r3), r0;
        ld.w r1, (sp+6);
        jsr  Leds_renderGridLine;
        ld.w r1, (sp+6);
        jsr  Solver_removePossibilitiesRelatedTo;
        addi sp, #8;
        ret;
        
// function void setHintAt(Array grid, int value, int x, int y)
//
Solver_setHintAt:
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
        ld.w r0, (r3++);
        ld.b r2, (sp+6);
        bclr r0, r2;
        beq  Solver_setHintAt_impossible;
        test r0;
        beq  Solver_setHintAt_return;
        jmp  Solver_setValueAt;
    Solver_setHintAt_impossible:
        move r0, r2;
        st.b (r3), r0;
        ld.w r3, #GRID_IMPOSSIBLE_FLAG_OFFSET;
        add  r3, r1;
        ld.b r0, #-1;
        st.b (r3), r0;
    Solver_setHintAt_return:
        ret;
        
// Returns zero if no value could be deduced
//
// function int getDeducedValueAt(Array grid, int x, int y)
//
    Solver_getDeducedValueAt_early_zero:
        clr r1;
        ret;
    Solver_getDeducedValueAt_return_zero:
        addi sp, #10;
        clr r1;
        ret;
Solver_getDeducedValueAt:
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
        push r1;
        ld.b r2, (sp+6);
        clr  r0;
        bset r0, r2;
        push r0;
        ld.b r0, (sp+6);
        push r0;
        ld.b r0, (sp+6);
        push r0;
        ld.b r2, (sp+0);
        move r3, r2;
        add  r3, r3;
        add  r3, r3;
        add  r3, r3;
        add  r3, r2;
        add  r3, r3;
        add  r3, r3;
        add  r3, r1;
        ld.w r2, (sp+4);
        ld.b r0, (sp+2);
        beq  Grid_mustBeValueByRow_second;
    Grid_mustBeValueByRow_first_loop:
        ld.w r1, (r3);
        and  r1, r2;
        bne  Grid_mustBeValueByRow_false;
        addq r3, #2;
        addq r3, #2;
        dec  r0;
        bne  Grid_mustBeValueByRow_first_loop;
    Grid_mustBeValueByRow_second:
        addq r3, #2;
        addq r3, #2;
        ld.b r0, #8;
        ld.b r1, (sp+2);
        sub  r0, r1;
        beq  Grid_mustBeValueByRow_true;
    Grid_mustBeValueByRow_second_loop:
        ld.w r1, (r3);
        and  r1, r2;
        bne  Grid_mustBeValueByRow_false;
        addq r3, #2;
        addq r3, #2;
        dec  r0;
        bne  Grid_mustBeValueByRow_second_loop;
    Grid_mustBeValueByRow_true:
        ld.b r1, (sp+12);
        addi sp, #18;
        ret;
    Grid_mustBeValueByRow_false:  
        ld.w r1, (sp+6);
        ld.b r3, (sp+2);
        add  r3, r3;
        add  r3, r3;
        add  r3, r1;
        ld.w r2, (sp+4);
        ld.b r0, (sp+0);
        beq  Grid_mustBeValueByColumn_second;
    Grid_mustBeValueByColumn_first_loop:
        ld.w r1, (r3);
        and  r1, r2;
        bne  Grid_mustBeValueByColumn_false;
        ld.b r1, #9 * 4;
        add  r3, r1;
        dec  r0;
        bne  Grid_mustBeValueByColumn_first_loop;
    Grid_mustBeValueByColumn_second:
        ld.b r1, #9 * 4;
        add  r3, r1;
        ld.b r0, #8;
        ld.b r1, (sp+0);
        sub  r0, r1;
        beq  Grid_mustBeValueByColumn_true;
    Grid_mustBeValueByColumn_second_loop:
        ld.w r1, (r3);
        and  r1, r2;
        bne  Grid_mustBeValueByColumn_false;
        ld.b r1, #9 * 4;
        add  r3, r1;
        dec  r0;
        bne  Grid_mustBeValueByColumn_second_loop;        
    Grid_mustBeValueByColumn_true:
        ld.b r1, (sp+12);
        addi sp, #18;
        ret;
    Grid_mustBeValueByColumn_false:
        ld.w r1, (sp+6);
        ld.b r2, (sp+0);
        move r3, r2;
        add  r3, r3;
        add  r3, r3;
        add  r3, r3;
        add  r3, r2;
        ld.b r2, (sp+2);
        add  r3, r2;
        add  r3, r3;
        add  r3, r3;
        add  r1, r3;        
        move r2, r1;
        addq r1, #2;
        ld.b r0, (sp+0);
        ld.w r3, #sectorStartNegativeOffsetFromSquareLookupFromY;
        add  r3, r0;
        ld.b r0, (r3);
        sub  r2, r0;
        ld.b r0, (sp+2);
        ld.w r3, #sectorStartNegativeOffsetFromSquareLookupFromX;
        add  r3, r0;
        ld.b r0, (r3);
        sub  r2, r0;
        ld.w r3, (sp+4);
    include "asm/Grid_mustBeValueBySector_checkSquare.asm";
        addq r2, #2;
    include "asm/Grid_mustBeValueBySector_checkSquare.asm";
        addq r2, #2;
    include "asm/Grid_mustBeValueBySector_checkSquare.asm";
        ld.b r0, #(6 * 4) + 2;
        add  r2, r0;
    include "asm/Grid_mustBeValueBySector_checkSquare.asm";
        addq r2, #2;
    include "asm/Grid_mustBeValueBySector_checkSquare.asm";
        addq r2, #2;
    include "asm/Grid_mustBeValueBySector_checkSquare.asm";
        ld.b r0, #(6 * 4) + 2;
        add  r2, r0;
    include "asm/Grid_mustBeValueBySector_checkSquare.asm";
        addq r2, #2;
    include "asm/Grid_mustBeValueBySector_checkSquare.asm";
        addq r2, #2;
    include "asm/Grid_mustBeValueBySector_checkSquare.asm";
        ld.b r1, (sp+12);
        addi sp, #18;
        ret;        
    Grid_mustBeValueBySector_false:
        addi sp, #8;
        ld.b r2, (sp+4);
        ld.w r0, (sp+6);
        ld.w r1, (sp+8);
        jmp  Solver_getDeducedValueAt_loop;
    Solver_getDeducedValueAt_return_value:
        ld.b r1, (sp+4);
        addi sp, #10;
        ret;
        
// function void refineGrid(Array grid)
//
Solver_refineGrid:
        push r1;
        clr  r0;
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
        ld.w r2, #-1;
    Solver_refineGrid_no_reset_y:
        inc  r2;
        ld.w r0, #-1;
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

// function void splitGrid(Array grid)
//
Solver_splitGrid:
        push r1;        
        ld.w r3, #SQUARE_COUNT * SQUARE_SIZE + 3;
        add  r3, r1;        
        addi sp, #-4;
        ld.b r1, #10;
        ld.b r0, #8;
        jmp  Solver_splitGrid_loop_start;
    Solver_splitGrid_y_loop:
        pop  r0;
        dec  r0;
        bmi  Solver_splitGrid_return;
    Solver_splitGrid_loop_start:
        push r0;
        ld.b r2, #9;
    Solver_splitGrid_x_loop:
        dec  r2;
        bmi  Solver_splitGrid_y_loop;
        addq r3, #-2;
        addq r3, #-2;
        ld.b r0, (r3);
        cmp  r0, r1;
        bpl  Solver_splitGrid_x_loop;
        addq r0, #-2;
        bmi  Solver_splitGrid_x_loop;
        beq  Solver_splitGrid_early_return;
        addq r0, #2;
        move r1, r0;
        st.b (sp+4), r2;
        ld.b r0, (sp+0);
        st.b (sp+2), r0;
        jmp  Solver_splitGrid_x_loop;
    Solver_splitGrid_early_return:
        pop  r0;
        st.b (sp+0), r0;
        st.b (sp+2), r2;
    Solver_splitGrid_return:        
        ld.w r1, (sp+4);
        jsr  Solver_splitGridAt;
        addi sp, #6;        
        ret;        

// function void splitGridAt(Array grid, int x, int y)
//
Solver_splitGridAt:
        move r0, sp;
        ld.w r2, #maxStackAddress + 1024;
        cmp  r0, r2;
        bls  Solver_splitGridAt_outOfStack;
        ld.w r2, #GRID_SIZE;
        sub  r0, r2;
        ld.b r2, (sp+4);
        ld.b r3, (sp+2);
        move sp, r0;
        push r0;
        push r1;
        addi sp, #-1;
        push r2;
        push r3;
        ld.b r2, (sp+0);
        move r3, r2;
        add  r3, r3;
        add  r3, r3;
        add  r3, r3;
        add  r3, r2;
        ld.b r2, (sp+2);
        add  r3, r2;
        add  r3, r3;
        add  r3, r3;
        add  r3, r1;
        ld.w r0, (r3);
        ld.b r1, #9;
    Solver_getAPossibilityAt_loop:
        btst r0, r1;
        bne  Solver_getAPossibilityAt_return;
        dec  r1;
        bne  Solver_getAPossibilityAt_loop;
    Solver_getAPossibilityAt_return:
        st.b (sp+4), r1;
        ld.w r1, (sp+5);
        ld.w r0, (sp+7);
        push r0;
        jsr  Grid_copyFromTo;
        addi sp, #2;
        jsr  Leds_addGridRenderDisable;
        ld.w r1, (sp+5);
        jsr  Solver_removePossibilityAt;
        jsr  Leds_undoGridRenderDisable;
        ld.w r1, (sp+5);
        jsr  Grid_isImpossible;
        bne  Solver_splitGridAt_impossible;
        ld.w r1, (sp+7);
        jsr  Solver_setValueAt;
        ld.w r1, (sp+7);
        jsr  Solver_solve;
        ld.w r1, (sp+5);
        jsr  Leds_renderGrid;
        move r0, sp;
        ld.w r2, #GRID_SIZE + 9;
        add  r0, r2;
        move sp, r0;
        ret;
    Solver_splitGridAt_outOfStack:
        ld.w r1, #messageOutOfMemory;
        jsr  Leds_renderThisMessage;
        jmp  $;        
    Solver_splitGridAt_impossible:
        ld.w r1, (sp+7);
        ld.w r0, (sp+5);
        push r0;
        jsr  Grid_copyFromTo;
        pop  r1;
        jsr  Solver_setValueAt;
        move r0, sp;
        ld.w r2, #GRID_SIZE + 9;
        add  r0, r2;
        move sp, r0;      
        ret;

// function int solve(Array grid)
//
Solver_solve:
        push r1;
        jsr  Grid_isImpossible;
        test r1;
        bne  Solver_solve_return;
        ld.w r1, (sp+0);
        jsr  Grid_isComplete;
        test r1;
        bne  Solver_solve_complete;
    Solver_solve_loop:
        move r0, sp;
        st.w refineStackReturn, r0;        
        ld.w r1, (sp+0);
        jsr  Solver_refineGrid;
    Solver_solve_refine_return:
        clr  r0;
        st.w refineStackReturn, r0;
        ld.w r1, (sp+0);
        jsr  Grid_isImpossible;
        test r1;
        bne  Solver_solve_return;
        ld.w r1, (sp+0);
        jsr  Grid_isComplete;
        test r1;
        bne  Solver_solve_complete;
        ld.w r1, (sp+0);
        jsr  Solver_splitGrid;
        ld.b r1, solutionCount;
        addq r1, #-2;
        bmi  Solver_solve_loop;
        addq r1, #2;
        addi sp, #2;
        ret;
    Solver_solve_complete:
        ld.b r1, solutionCount;
        bne  Solver_solve_already_complete;
        jsr  Leds_addGridRenderDisable;
        ld.w r1, #messageSolution;
        jsr  Leds_renderThisMessage;
        ld.b r1, solutionCount;
    Solver_solve_already_complete:
        inc  r1;
        st.b solutionCount, r1;
        addi sp, #2;
        ret;
    Solver_solve_return:
        ld.b r1, solutionCount;
        addi sp, #2;
        ret;