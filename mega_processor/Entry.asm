
RAM_END equ 0x8000;

org 0;
    jmp  start;
    
org 0xF;

start:
    ld.w r0, #RAM_END;
    move sp, r0;
    jsr  Main_main;
    jmp  $;
    
include "asm/Grid.asm";
    
include "jack/Main.asm";
include "jack/Grid.asm";
include "jack/Solver.asm";
include "jack/Leds.asm";
    
Math_multiply:
    ld.w r0, (sp+2);
    mulu;
    move r1, r2;
    ret;

Math_divide:
    move r0, r1;
    ld.w r1, (sp+2);
    divu;
    move r1, r2;
    ret;

org 0xA000; // Blank LEDs on load
    ds   256, 0;