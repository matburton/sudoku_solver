
LED_START equ 0xA000;
LED_SIZE  equ 256;

gridRenderDisableCount:
    db   0;

numberShapes: // Numbers should look horizontally backwards here
    db   0b00, 0b10, 0b11, 0b11, 0b01, 0b11, 0b11, 0b11, 0b11, 0b11;
    db   0b00, 0b10, 0b10, 0b10, 0b11, 0b01, 0b01, 0b10, 0b11, 0b11;
    db   0b00, 0b10, 0b11, 0b11, 0b11, 0b11, 0b11, 0b10, 0b11, 0b11;
    db   0b00, 0b10, 0b01, 0b10, 0b10, 0b10, 0b11, 0b10, 0b11, 0b10;
    db   0b00, 0b10, 0b11, 0b11, 0b10, 0b11, 0b11, 0b10, 0b11, 0b10;

valueStartOffsetLookupFromY:
    dw   (0 * 9 + 8) * 4 + 2;
    dw   (1 * 9 + 8) * 4 + 2;
    dw   (2 * 9 + 8) * 4 + 2;
    dw   (3 * 9 + 8) * 4 + 2;
    dw   (4 * 9 + 8) * 4 + 2;
    dw   (5 * 9 + 8) * 4 + 2;
    dw   (6 * 9 + 8) * 4 + 2;
    dw   (7 * 9 + 8) * 4 + 2;
    dw   (8 * 9 + 8) * 4 + 2;

ledStartLookupFromY:
    dw   LED_START + (1  * 4);
    dw   LED_START + (7  * 4);
    dw   LED_START + (13 * 4);
    dw   LED_START + (21 * 4);
    dw   LED_START + (27 * 4);
    dw   LED_START + (33 * 4);
    dw   LED_START + (41 * 4);
    dw   LED_START + (47 * 4);
    dw   LED_START + (53 * 4);
    
MESSAGE_SIZE equ 5 * 4;

LED_MESSAGE_START equ LED_START + LED_SIZE - MESSAGE_SIZE;
    
messageSolving:
    dw   0b0000000000001110, 0b0000000000000001;
    dw   0b0101001011000010, 0b0000001110100100;
    dw   0b0101001010101110, 0b0000000010101101;
    dw   0b0101001010101000, 0b0000001010110101;
    dw   0b0010011001101110, 0b1010101110100101;
    
messageSolution:
    dw   0b1101110100101010, 0b0111001110101001;
    dw   0b0100100101101010, 0b0100000010101001;
    dw   0b0100100110101010, 0b0110000110101001;
    dw   0b0100100100101010, 0b0000000010101001;
    dw   0b1101110100101110, 0b0010001110111011;

messageUnique:
    dw   0b1110100101010000, 0b0000110101001110;
    dw   0b0100101101010000, 0b0000010101001010;
    dw   0b0100110101010000, 0b0000110101001010;
    dw   0b0100100101010000, 0b0000010101001010;
    dw   0b1110100101110000, 0b0000110111011110;
    
messageNotUnique:
    dw   0b1000111011101001, 0b0111011101001010;
    dw   0b1000010010101011, 0b0101001001011010;
    dw   0b1000010010101101, 0b0101001001101010;
    dw   0b1000010010101001, 0b0101001001001010;
    dw   0b1000010011101001, 0b1111011101001011;
    
messageImpossible:
    dw   0b1101110100010111, 0b1110010011011101;
    dw   0b0101010110110010, 0b0010010101000101;
    dw   0b0101110101010010, 0b0110010011011101;
    dw   0b0100010100010010, 0b0010010101010001;
    dw   0b1100010100010111, 0b1110110011011101;
    
messageOutOfMemory:
    dw   0b0100010011101001, 0b1010011010001011;
    dw   0b0110110010101011, 0b1010101011011001;
    dw   0b0101010010101101, 0b1110011010101011;
    dw   0b0100010010101001, 0b0100101010001001;
    dw   0b0100010011101001, 0b0100101010001011;
    
messages:
    dw   messageSolving;
    dw   messageImpossible;
    dw   messageUnique;
    dw   messageNotUnique;