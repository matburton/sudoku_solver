        ld.w r0, (r2++);
        cmp  r2, r1;
        beq  $+5;
        and  r0, r3;
        bne  Grid_mustBeValueBySector_false;