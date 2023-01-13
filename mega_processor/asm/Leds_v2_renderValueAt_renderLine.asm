        ld.w r0, (r2);
        ld.w r1, (r3++);
        and  r0, r1;
        ld.w r1, (r3++);
        or   r0, r1;
        st.w (r2++), r0;