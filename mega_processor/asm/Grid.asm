
SQUARE_COUNT equ 81;
GRID_SIZE    equ SQUARE_COUNT * 4 + 2;

GRID_INCOMPLETE_SQUARE_COUNT_OFFSET equ GRID_SIZE - 2;
GRID_IMPOSSIBLE_FLAG_OFFSET         equ GRID_SIZE - 1;

// function int gridByteSize()
//
Grid_gridByteSize:
        ld.w r1, #GRID_SIZE;
        ret;
        
// function Array initialise(Array grid)
//
Grid_initialise:
        ld.b r2, #SQUARE_COUNT / 3;
        move r3, r1;
        ld.w r0, #0b1111111110;
        ld.w r1, #0x900;
    Grid_initialise_loop:
        st.w (r3++), r0;
        st.w (r3++), r1;
        st.w (r3++), r0;
        st.w (r3++), r1;
        st.w (r3++), r0;
        st.w (r3++), r1;
        dec  r2;
        bne  Grid_initialise_loop;
        ld.b r0, #SQUARE_COUNT;
        st.w (r3), r0;
        ret;
        
// function void copyFromTo(Array source, Array target)
//
Grid_copyFromTo:
        move r2, r1;
        ld.w r3, (sp+2);
        ld.b r0, #SQUARE_COUNT;
    Grid_copyFromTo_loop:
        ld.w r1, (r2++);
        st.w (r3++), r1;
        ld.w r1, (r2++);
        st.w (r3++), r1;
        dec  r0;
        bne  Grid_copyFromTo_loop;
        ld.w r1, (r2++);
        st.w (r3++), r1;
        ret;
        
// function void setSquareValue(Array grid, int value, int x, int y)
//
Grid_setSquareValue:
        ld.w r2, #GRID_INCOMPLETE_SQUARE_COUNT_OFFSET;
        add  r2, r1;
        ld.b r0, (r2);
        dec  r0;
        st.b (r2), r0;
    include "asm/Grid_getSquareOffset.asm";
        add  r3, r1;
        ld.b r0, #0;
        ld.b r2, (sp+6);
        bset r0, r2;
        st.w (r3), r0;
        ld.w r0, #0x100;
        or   r0, r2;
        addq r3, #2;
        st.w (r3), r0;
        ret;
        
// Returns 0 if the square has multiple possibilities or no possibilities
//
// function int getSquareValue(Array grid, int x, int y)
//
Grid_getSquareValue:
        nop;
    include "asm/Grid_getSquareOffset.asm";
        add  r3, r1;
        addq r3, #2;
        ld.b r1, (r3);
        ret;
        
// Returns the new square value if the square was previously incomplete,
// i.e. had multiple possibilities, but now only has one. Otherwise
// returns zero, e.g. if the square is still incomplete or did not have
// the given value as a possibility
//
// function int removeSquarePossibility(Array grid, int value, int x, int y)
//
Grid_removeSquarePossibility:
        nop;
    include "asm/Grid_getSquareOffset.asm";
        add  r3, r1;
        ld.w r0, (r3);
        ld.w r2, (sp+6);
        bclr r0, r2;
        bne  Grid_removeSquarePossibility_continue;
        ld.b r1, #0;
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
        ld.b r1, #0;
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
        ret;
        
// function boolean squareHasPossibility(Array grid, int value, int x, int y)
//
Grid_squareHasPossibility:
        nop;
    include "asm/Grid_getSquareOffset.asm";
        add  r3, r1;
        ld.w r0, (r3);
        ld.w r2, (sp+6);
        ld.b r1, #0;
        btst r0, r2;
        beq  Grid_squareHasPossibility_return;
        dec  r1;
    Grid_squareHasPossibility_return:
        ret;
        
// function int getPossibilityCount(Array grid, int x, int y)
//
Grid_getPossibilityCount:
        nop;
    include "asm/Grid_getSquareOffset.asm";
        add  r3, r1;
        addq r3, #2;
        inc  r3;
        ld.b r1, (r3);
        ret;
        
// function boolean isImpossible(Array grid)
//
Grid_isImpossible:
        ld.w r2, #GRID_IMPOSSIBLE_FLAG_OFFSET;
        add  r2, r1;
        ld.b r1, (r2);
        sxt  r1;
        ret;
       
// function boolean isComplete(Array grid)
//       
Grid_isComplete:
        ld.w r2, #GRID_INCOMPLETE_SQUARE_COUNT_OFFSET;
        add  r2, r1;
        ld.b r1, #0;
        ld.b r0, (r2);
        bne  Grid_isComplete_return;
        dec  r1;
    Grid_isComplete_return:
        ret;
        
// function boolean mustBeValueByRow(Array grid, int mask, int x, int y)
//
Grid_mustBeValueByRow:
        ld.b r2, (sp+2);
        move r3, r2;
        add  r3, r3;
        add  r3, r3;
        add  r3, r3;
        add  r3, r2;
        add  r3, r3;
        add  r3, r3;
        add  r3, r1;
        ld.b r0, #9;
        ld.w r2, (sp+6);
        ld.b r1, (sp+4);
        add  r1, r1;
        add  r1, r1;
        add  r1, r3;
        push r1;
        jmp  Grid_mustBeValueByRow_start;
    Grid_mustBeValueByRow_loop:
        dec  r0;
        beq  Grid_mustBeValueByRow_true;
        addq r3, #2;
        addq r3, #2;
    Grid_mustBeValueByRow_start:
        ld.w r1, (r3);
        and  r1, r2;
        beq  Grid_mustBeValueByRow_loop;
        ld.w r1, (sp+0);
        cmp  r3, r1;
        beq  Grid_mustBeValueByRow_loop;
        addi sp, #2;
        ld.w r1, #0;
        ret;
    Grid_mustBeValueByRow_true:
        addi sp, #2;
        ld.w r1, #-1;
        ret;
        
// function boolean mustBeValueByColumn(Array grid, int mask, int x, int y)
//
Grid_mustBeValueByColumn:
        nop;
    include "asm/Grid_getSquareOffset.asm";
        add  r3, r1;
        push r3;
        add  r2, r2;
        add  r2, r2;
        move r3, r2;
        add  r3, r1;
        ld.b r0, #9;
        ld.w r2, (sp+8);jmp  Grid_mustBeValueByColumn_start;
    Grid_mustBeValueByColumn_loop:
        dec  r0;
        beq  Grid_mustBeValueByColumn_true;
        ld.b r1, #9 * 4;
        add  r3, r1;
    Grid_mustBeValueByColumn_start:
        ld.w r1, (r3);
        and  r1, r2;
        beq  Grid_mustBeValueByColumn_loop;
        ld.w r1, (sp+0);
        cmp  r3, r1;
        beq  Grid_mustBeValueByColumn_loop;
        addi sp, #2;
        ld.w r1, #0;
        ret;
    Grid_mustBeValueByColumn_true:
        addi sp, #2;
        ld.w r1, #-1;
        ret;
                
// function Array getSquare(Array grid, int x, int y)
//
Grid_getSquare:
        nop;
    include "asm/Grid_getSquareOffset.asm";
        add  r1, r3;
        ret;
        
// function int calculateValue(int possibilities)
//
Grid_calculateValue:
        ld.b r0, #1;
        ld.b r2, #0;
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
        ret;

// function int toMask(int value)
//
Grid_toMask:
        ld.b r0, #0;
        bset r0, r1;
        move r1, r0;
        ret;