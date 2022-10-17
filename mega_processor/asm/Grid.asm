
Grid_gridByteSize:
        ld.w r1, #326;
        ret;
        
Grid_initialise:
        ld.b r2, #27;
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
        ld.b r0, #81;
        st.w (r3), r0;
        ret;
        
Grid_isImpossible:
        ld.w r2, #325;
        add  r2, r1;
        ld.b r1, (r2);
        sxt  r1;
        ret;
        
Grid_copyFromTo:
        move r2, r1;
        ld.w r3, (sp+2);
        ld.b r0, #54;
    Grid_copyFromTo_loop:
        ld.w r1, (r2++);
        st.w (r3++), r1;
        ld.w r1, (r2++);
        st.w (r3++), r1;
        ld.w r1, (r2++);
        st.w (r3++), r1;
        dec  r0;
        bne  Grid_copyFromTo_loop;
        ld.w r1, (r2++);
        st.w (r3++), r1;
        ret;

Grid_toMask:
        ld.b r0, #0;
        bset r0, r1;
        move r1, r0;
        ret;