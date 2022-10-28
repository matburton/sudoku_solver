    // Returns the new square value if the square was previously incomplete,
    // i.e. had multiple possibilities, but now only has one. Otherwise
    // returns zero, e.g. if the square is still incomplete or did not have
    // the given value as a possibility
    //
    // r0: x, r1: grid, r2: y, sp: value
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
        ld.b r1, #0;
        jmp  Grid_removeSquarePossibility_return;
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
        jmp  Grid_removeSquarePossibility_return;
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
        jmp  Grid_removeSquarePossibility_return;
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