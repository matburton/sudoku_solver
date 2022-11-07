
SQUARE_COUNT equ 81;
GRID_SIZE    equ SQUARE_COUNT * 4 + 2;
SQUARE_SIZE  equ 4;

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
        
// function boolean isImpossible(Array grid)
//
Grid_isImpossible:
        ld.w r2, #GRID_IMPOSSIBLE_FLAG_OFFSET;
        add  r2, r1;
        ld.b r1, (r2);
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
        
// function boolean mustBeValue(Array grid, int value, int x, int y)
//
Grid_mustBeValue:
        push r1;
        ld.b r2, (sp+8);
        ld.b r0, #0;
        bset r0, r2;
        push r0;
        ld.b r0, (sp+8);
        push r0;
        ld.b r0, (sp+8);
        push r0;
        jsr  Grid_mustBeValueByRow;
        test r1;
        bne  Grid_mustBeValue_return;
        ld.w r1, (sp+6);
        jsr  Grid_mustBeValueByColumn;
        test r1;
        bne  Grid_mustBeValue_return;
        ld.w r1, (sp+6);
        jsr  Grid_mustBeValueBySector;
    Grid_mustBeValue_return:
        addi sp, #8;
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
        ld.w r2, (sp+6);
        ld.b r0, (sp+4);
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
        ld.b r1, (sp+4);
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
        ld.w r1, #-1;
        ret;
    Grid_mustBeValueByRow_false:
        ld.w r1, #0;
        ret;
        
// function boolean mustBeValueByColumn(Array grid, int mask, int x, int y)
//
Grid_mustBeValueByColumn:
        ld.b r3, (sp+4);
        add  r3, r3;
        add  r3, r3;
        add  r3, r1;
        ld.w r2, (sp+6);
        ld.b r0, (sp+2);
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
        ld.b r1, (sp+2);
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
        ld.w r1, #-1;
        ret;
    Grid_mustBeValueByColumn_false:
        ld.w r1, #0;
        ret;
        
// function boolean mustBeValueBySector(Array grid, int mask, int x, int y)
//
Grid_mustBeValueBySector:
        nop;
    include "asm/Grid_getSquareOffset.asm";
        add  r1, r3;        
        move r2, r1;
        addq r1, #2;
        ld.b r0, (sp+2);
        ld.w r3, #sectorStartNegativeOffsetFromSquareLookupFromY;
        add  r3, r0;
        ld.b r0, (r3);
        sub  r2, r0;
        ld.b r0, (sp+4);
        ld.w r3, #sectorStartNegativeOffsetFromSquareLookupFromX;
        add  r3, r0;
        ld.b r0, (r3);
        sub  r2, r0;
        ld.w r3, (sp+6);
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
        ld.w r1, #-1;
        ret;
    Grid_mustBeValueBySector_false:
        ld.b r1, #0;
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