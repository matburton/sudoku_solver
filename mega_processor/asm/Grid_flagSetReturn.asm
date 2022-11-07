        buc  $+9;
        ld.w r3, #gridFlagSetReturn;
        ld.w r0, (r3++);
        move sp, r0;
        ld.w r0, (r3);
        jmp  (r0);