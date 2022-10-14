
RAM_END equ 0x8000;

org 0;
    jmp  start;
    
org 0xF;

start:
    ld.w r0, #RAM_END;
    move sp, r0;
    jsr  Main_main;
    jmp  $;
    
include "Main.asm";

org 0xA000; // Blank LEDs on load
    ds   256, 0;