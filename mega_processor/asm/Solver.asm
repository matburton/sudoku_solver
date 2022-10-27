
Solver_removePossibilityAt:
        ld.b r0, (sp+6);
        ld.b r2, (sp+4);
        ld.b r3, (sp+2);
        addi sp, #-2;
        push r1;
        push r0;
        push r2;
        push r3;
        jsr  Grid_removeSquarePossibility;
        bne  Solver_removePossibilityAt_value;
        addi sp, #10;
        ret;
    Solver_removePossibilityAt_value:
        pop  r0;
        addi sp, #4;
        st.b (sp+2), r1;
        ld.w r1, (sp+0);
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