    // Assumes x, y words under a return address on the stack
    // Puts the square offset in r3, Clobbers r2 with x
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