
RAM_END equ 0x8000;

include "asm/Leds_startup.asm";

org 0;
        jmp  start;
    
org 0x4;
        reti;
    
org 0x8;
        jmp  $;
    
org 0xC;
        jmp  $;

start:
        ld.w r0, #RAM_END - GRID_SIZE;
        move sp, r0;
        move r1, r0;
        push r1;
        jsr  Grid_initialise;
        ld.w r1, (sp+0);
        jsr  Input_copyUserHintsToGrid;
        ld.w r1, #messageSolving;       
        jsr  Leds_renderThisMessage;       
        ld.w r1, (sp+0);
        jsr  Solver_solve;
        jsr  Leds_renderMessage;
        jmp  $;
    
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