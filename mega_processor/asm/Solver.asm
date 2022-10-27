
// function void removePossibilityAt(Array grid, int value, int x, int y)
//
Solver_removePossibilityAt:
        ld.b r3, (sp+6);
        ld.b r0, (sp+4);
        ld.b r2, (sp+2);
        addi sp, #-2;
        push r1;
        push r3;
        jsr  Grid_removeSquarePossibility;
        bne  Solver_removePossibilityAt_value;
        addi sp, #6;
        ret;
    Solver_removePossibilityAt_value:
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