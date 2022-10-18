
SQUARE_COUNT equ 81;
GRID_SIZE    equ SQUARE_COUNT * 4 + 2;

Grid_gridByteSize:
        ld.w r1, #GRID_SIZE;
        ret;
        
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
        
Grid_isImpossible:
        ld.w r2, #GRID_SIZE - 1;
        add  r2, r1;
        ld.b r1, (r2);
        sxt  r1; // TODO: Remove in the future
        ret;
        
Grid_isComplete:
        ld.w r2, #GRID_SIZE - 2;
        add  r2, r1;
        ld.b r1, #0;
        ld.b r0, (r2);
        bne  Grid_isComplete_return;
        dec  r1;
    Grid_isComplete_return:
        ret;
        
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

Grid_toMask:
        ld.b r0, #0;
        bset r0, r1;
        move r1, r0;
        ret;