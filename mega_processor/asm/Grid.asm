
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
        clr  r1;
        ld.b r0, (r2);
        bne  Grid_isComplete_return;
        dec  r1;
    Grid_isComplete_return:
        ret;