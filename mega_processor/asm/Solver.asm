
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