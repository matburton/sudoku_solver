        ld.w r1, (r3++);
        ld.w r0, (r2);
        or   r0, r1;
        st.w (r2++), r0;