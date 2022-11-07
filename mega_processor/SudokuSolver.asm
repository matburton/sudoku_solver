
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
    ld.w r0, #RAM_END;
    move sp, r0;
    jsr  Main_main;
    jmp  $;
    
include "asm/Grid.asm";
include "asm/Solver.asm";
include "asm/Leds.asm";
    
include "jack/Main.asm";

include "asm/Grid_data.asm";
include "asm/Solver_data.asm";
include "asm/Leds_data.asm";

maxStackAddress:
    nop;