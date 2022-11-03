
RAM_END equ 0x8000;

org 0;
    jmp  start;
    

include "asm/Leds_startup.asm";

org 0x10;

start:
    ld.w r0, #RAM_END;
    move sp, r0;
    jsr  Main_main;
    jmp  $;
    
include "asm/Grid.asm";
include "asm/Solver.asm";
include "asm/Leds.asm";
    
include "jack/Main.asm";
include "jack/Grid.asm";
include "jack/Solver.asm";
include "jack/Leds.asm";

include "asm/Grid_data.asm";
include "asm/Solver_data.asm";
include "asm/Leds_data.asm";

maxStackAddress:
    nop;