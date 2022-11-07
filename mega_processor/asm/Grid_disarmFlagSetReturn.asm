        ld.w r3, #gridFlagSetReturn + 2;
        pop  r0;
        st.w (r3), r0;
        addq r3, #-2;
        pop  r0;
        st.w (r3), r0;