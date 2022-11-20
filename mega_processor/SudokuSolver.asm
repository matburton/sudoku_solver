
RAM_END equ 0x8000;

org 0;
        jmp  start;
    
org 0x4;
        reti;
    
org 0x8;
        jmp  $;
    
org 0xC;
        jmp  $;

start:
        ld.b r0, #0;                     // for reset
        st.w refineStackReturn, r0;      // for reset
        st.b gridRenderDisableCount, r0; // for reset
        st.b solutionCount, r0;          // for reset
        ld.w r0, #RAM_END - GRID_SIZE;
        move sp, r0;
        push r0;
        jsr  Leds_renderStartupLeds;
        ld.w r1, (sp+0);
        jsr  Input_copyUserHintsToGrid;
        ld.w r1, (sp+0);
        jsr  Solver_solve;
        jsr  Leds_renderMessage;
        ld.w r0, #0b111111110000;
    start_reset_loop:
        ld.w r1, GEN_IO_INPUT;
        and  r1, r0;
        cmp  r1, r0;
        beq  start_reset_loop;
        jmp  start;
    
include "asm/Grid.asm";
include "asm/Solver.asm";
include "asm/Leds.asm";
include "asm/Input.asm";

include "asm/Grid_data.asm";
include "asm/Solver_data.asm";
include "asm/Leds_data.asm";
include "asm/Input_data.asm";

maxStackAddress:
        nop;