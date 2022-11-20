
Leds_renderStartupLeds:
        ld.w r2, #LED_START;
        ld.w r3, #startupLeds;
        ld.b r1, #LED_SIZE / 2 / 8;
    Leds_renderStartupLeds_loop:
        ld.w r0, (r3++);
        st.w (r2++), r0;
        ld.w r0, (r3++);
        st.w (r2++), r0;
        ld.w r0, (r3++);
        st.w (r2++), r0;
        ld.w r0, (r3++);
        st.w (r2++), r0;
        ld.w r0, (r3++);
        st.w (r2++), r0;
        ld.w r0, (r3++);
        st.w (r2++), r0;
        ld.w r0, (r3++);
        st.w (r2++), r0;
        ld.w r0, (r3++);
        st.w (r2++), r0;
        dec  r1;
        bne  Leds_renderStartupLeds_loop;
        ret;

// function void addGridRenderDisable()
//
Leds_addGridRenderDisable:
        ld.b r0, gridRenderDisableCount;
        inc  r0;
        st.b gridRenderDisableCount, r0;
        ret;

// function void undoGridRenderDisable()
//
Leds_undoGridRenderDisable:
        ld.b r0, gridRenderDisableCount;
        dec  r0;
        st.b gridRenderDisableCount, r0;
        ret;

// function void renderGrid(Array grid)
//    
Leds_renderGrid:
        ld.b r0, gridRenderDisableCount;
        bne  Leds_renderGrid_return;
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
    Leds_renderGrid_return:
        ret;

// function void renderGridLine(Array grid, int y)
//
Leds_renderGridLine:

        ld.b r0, gridRenderDisableCount;
        beq  Leds_renderGridLine_setup;
        ret;
        
    Leds_renderGridLine_setup:

        move r3, r1;
        ld.b r0, (sp+2);
        add  r0, r0;
        ld.w r2, #valueStartOffsetLookupFromY;
        add  r2, r0;   // Make r3 point to
        ld.w r1, (r2); // value of the last
        add  r3, r1;   // square in the row
        
        addi sp, #-2;
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
    
        st.w (sp+4), r1;
    
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
        
        ld.w r0, (sp+4);
        add  r1, r1;
        bcc  Leds_renderGridLine_end_carry;
        inc  r0;
    Leds_renderGridLine_end_carry:
        ld.w r2, (sp+0);
        st.w (r2++), r1;
        st.w (r2++), r0;
        st.w (sp+0), r2;
        
        ld.w r0, (sp+2);
        ld.w r2, #numberShapes + 4 * 10;
        cmp  r2, r0;
        bne  Leds_renderGridLine_loop;
        addi sp, #6;
        ret;
        
Leds_renderMessage:
        add  r1, r1;
        ld.w r3, #messages;
        add  r3, r1;
        ld.w r1, (r3);        
Leds_renderThisMessage:
        move r3, r1;
        ld.w r2, #LED_MESSAGE_START;
        ld.w r0, (r3++);
        st.w (r2++), r0;
        ld.w r0, (r3++);
        st.w (r2++), r0;
        ld.w r0, (r3++);
        st.w (r2++), r0;
        ld.w r0, (r3++);
        st.w (r2++), r0;
        ld.w r0, (r3++);
        st.w (r2++), r0;
        ld.w r0, (r3++);
        st.w (r2++), r0;
        ld.w r0, (r3++);
        st.w (r2++), r0;
        ld.w r0, (r3++);
        st.w (r2++), r0;
        ld.w r0, (r3++);
        st.w (r2++), r0;
        ld.w r0, (r3++);
        st.w (r2++), r0;
        ret;