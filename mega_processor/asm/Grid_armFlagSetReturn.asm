        ld.w r3, #gridFlagSetReturn;
        ld.w r0, (r3++);
        push r0;
        ld.w r0, (r3);
        push r0;
        addq r3, #-2;
        move r0, sp;
        st.w (r3++), r0;
        ori  ps, #0b10000000;