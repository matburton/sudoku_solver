
Grid_gridByteSize:
        ld.w r1, #326;
        ret;
        
Grid_initialise:
        ld.b r2, #27;
        move r3, r1;
        ld.w r0, #0b111111111;
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
        
possibilityValueMasks:
        dw   0b000000000;
        dw   0b000000001;
        dw   0b000000010;
        dw   0b000000100;
        dw   0b000001000;
        dw   0b000010000;
        dw   0b000100000;
        dw   0b001000000;
        dw   0b010000000;
        dw   0b100000000;

Grid_toMask:
        ld.w r3, #possibilityValueMasks;
        add  r3, r1;
        add  r3, r1;
        ld.w r1, (r3);
        ret;