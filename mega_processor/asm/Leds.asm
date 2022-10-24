
// function void renderGrid(Array grid)
//    
Leds_renderGrid:
        push r1;
        ld.b r0, #9;
    Leds_renderGrid_loop:
        ld.w r1, (sp+0);
        dec  r0;
        push r0;
        jsr  Leds_renderGridLine;
        pop  r0;        
        bne  Leds_renderGrid_loop;
        addi sp, #2;
        ret;

// function void renderGridLine(Array grid, int y)
//
Leds_renderGridLine:

        move r3, r1;
        ld.b r0, (sp+2);
        add  r0, r0;
        ld.w r2, #valueStartOffsetLookupFromY;
        add  r2, r0;   // Make r3 point to
        ld.w r1, (r2); // value of the last
        add  r3, r1;   // square in the row
        
        ld.w r2, #numberShapes;  // Push static
        push r2;                 // digit line

        ld.w r2, #ledStartLookupFromY; 
        add  r2, r0;
        ld.w r0, (r2); // Push LED
        push r0;       // position       

        jmp Leds_renderGridLine_start;
        
    Leds_renderGridLine_loop:
        
        ld.b r2, #10;    // Move to
        add  r0, r2;     // next line
        st.w (sp+2), r0; // of digits
        
        ld.b r0, #8 * 4;
        add  r3, r0;
    
    Leds_renderGridLine_start:
        
        ld.b r0, (r3);   // Add
        ld.w r2, (sp+2); // value
        add  r2, r0;     // in 9th
        ld.b r1, (r2);   // square
        add  r1, r1;     // to r1
        add  r1, r1;
        add  r1, r1;
        addq r3, #-2;
        addq r3, #-2;
        
    include "asm/Leds_addValue.asm";
        add  r1, r1;
        
    include "asm/Leds_addValue.asm";
        addq r1, #1; // Divider
        add  r1, r1;
        add  r1, r1;
        add  r1, r1;
        
    include "asm/Leds_addValue.asm";
        
        ld.w r2, (sp+0); // Write word
        st.w (r2), r1;   // to LEDs
    
        ld.b r0, (r3);   // Add
        ld.w r2, (sp+2); // value
        add  r2, r0;     // in 5th
        ld.b r1, (r2);   // square
        add  r1, r1;     // to r1
        add  r1, r1;
        add  r1, r1;
        addq r3, #-2;
        addq r3, #-2;
        
    include "asm/Leds_addValue.asm";
        addq r1, #1; // Divider
        add  r1, r1;
        add  r1, r1;
        add  r1, r1;
        
    include "asm/Leds_addValue.asm";
        add  r1, r1;

    include "asm/Leds_addValue.asm";
        add  r1, r1;
        
        ld.b r0, (r3);   // Add
        ld.w r2, (sp+2); // value
        add  r2, r0;     // in 1st
        ld.b r0, (r2);   // square
        or   r1, r0;     // to r1
        
        ld.w r2, (sp+0);
        add  r1, r1;
        bcc  Leds_renderGridLine_end_carry;
        ld.w r0, (r2);
        inc  r0;
        st.w (r2), r0;
    Leds_renderGridLine_end_carry:
        addq r2, #-2;
        st.w (r2++), r1;
        addq r2, #2;     // Move to
        addq r2, #2;     // the next  
        st.w (sp+0), r2; // LED line
        
        ld.w r0, (sp+2);
        ld.w r2, #numberShapes + 4 * 10;
        cmp  r2, r0;
        beq  Leds_renderGridLine_return;
        jmp  Leds_renderGridLine_loop;
    
    Leds_renderGridLine_return:
        addi sp, #4;
        ret;