
xToLedOffset:
    db   0, 0, 0, 0, 1, 2, 2, 2, 2;
    
xToDigitLookupOffset:
    dw 0, 180, 360, 540, 720, 900, 1080, 1260, 1440;

digitLookup: // Left side of 'screen'
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000100; // Value 1 @ 0 line 1
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000100; // Value 1 @ 0 line 2
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000100; // Value 1 @ 0 line 3
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000100; // Value 1 @ 0 line 4
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000100; // Value 1 @ 0 line 5
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000110; // Value 2 @ 0 line 1
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000100; // Value 2 @ 0 line 2
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000110; // Value 2 @ 0 line 3
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000010; // Value 2 @ 0 line 4
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000110; // Value 2 @ 0 line 5
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000110; // Value 3 @ 0 line 1
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000100; // Value 3 @ 0 line 2
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000110; // Value 3 @ 0 line 3
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000100; // Value 3 @ 0 line 4
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000110; // Value 3 @ 0 line 5
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000010; // Value 4 @ 0 line 1
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000110; // Value 4 @ 0 line 2
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000110; // Value 4 @ 0 line 3
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000100; // Value 4 @ 0 line 4
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000100; // Value 4 @ 0 line 5
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000110; // Value 5 @ 0 line 1
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000010; // Value 5 @ 0 line 2
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000110; // Value 5 @ 0 line 3
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000100; // Value 5 @ 0 line 4
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000110; // Value 5 @ 0 line 5
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000110; // Value 6 @ 0 line 1
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000010; // Value 6 @ 0 line 2
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000110; // Value 6 @ 0 line 3
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000110; // Value 6 @ 0 line 4
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000110; // Value 6 @ 0 line 5
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000110; // Value 7 @ 0 line 1
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000100; // Value 7 @ 0 line 2
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000100; // Value 7 @ 0 line 3
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000100; // Value 7 @ 0 line 4
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000100; // Value 7 @ 0 line 5
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000110; // Value 8 @ 0 line 1
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000110; // Value 8 @ 0 line 2
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000110; // Value 8 @ 0 line 3
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000110; // Value 8 @ 0 line 4
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000110; // Value 8 @ 0 line 5
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000110; // Value 9 @ 0 line 1
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000110; // Value 9 @ 0 line 2
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000110; // Value 9 @ 0 line 3
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000100; // Value 9 @ 0 line 4
    dw   0b1111111111111001; // Mask @ x = 0
    dw   0b0000000000000100; // Value 9 @ 0 line 5
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000100000; // Value 1 @ 1 line 1
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000100000; // Value 1 @ 1 line 2
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000100000; // Value 1 @ 1 line 3
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000100000; // Value 1 @ 1 line 4
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000100000; // Value 1 @ 1 line 5
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000110000; // Value 2 @ 1 line 1
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000100000; // Value 2 @ 1 line 2
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000110000; // Value 2 @ 1 line 3
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000010000; // Value 2 @ 1 line 4
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000110000; // Value 2 @ 1 line 5
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000110000; // Value 3 @ 1 line 1
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000100000; // Value 3 @ 1 line 2
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000110000; // Value 3 @ 1 line 3
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000100000; // Value 3 @ 1 line 4
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000110000; // Value 3 @ 1 line 5
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000010000; // Value 4 @ 1 line 1
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000110000; // Value 4 @ 1 line 2
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000110000; // Value 4 @ 1 line 3
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000100000; // Value 4 @ 1 line 4
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000100000; // Value 4 @ 1 line 5
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000110000; // Value 5 @ 1 line 1
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000010000; // Value 5 @ 1 line 2
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000110000; // Value 5 @ 1 line 3
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000100000; // Value 5 @ 1 line 4
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000110000; // Value 5 @ 1 line 5
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000110000; // Value 6 @ 1 line 1
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000010000; // Value 6 @ 1 line 2
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000110000; // Value 6 @ 1 line 3
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000110000; // Value 6 @ 1 line 4
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000110000; // Value 6 @ 1 line 5
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000110000; // Value 7 @ 1 line 1
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000100000; // Value 7 @ 1 line 2
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000100000; // Value 7 @ 1 line 3
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000100000; // Value 7 @ 1 line 4
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000100000; // Value 7 @ 1 line 5
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000110000; // Value 8 @ 1 line 1
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000110000; // Value 8 @ 1 line 2
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000110000; // Value 8 @ 1 line 3
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000110000; // Value 8 @ 1 line 4
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000110000; // Value 8 @ 1 line 5
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000110000; // Value 9 @ 1 line 1
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000110000; // Value 9 @ 1 line 2
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000110000; // Value 9 @ 1 line 3
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000100000; // Value 9 @ 1 line 4
    dw   0b1111111111001111; // Mask @ x = 1
    dw   0b0000000000100000; // Value 9 @ 1 line 5
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000100000000; // Value 1 @ 2 line 1
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000100000000; // Value 1 @ 2 line 2
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000100000000; // Value 1 @ 2 line 3
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000100000000; // Value 1 @ 2 line 4
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000100000000; // Value 1 @ 2 line 5
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000110000000; // Value 2 @ 2 line 1
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000100000000; // Value 2 @ 2 line 2
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000110000000; // Value 2 @ 2 line 3
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000010000000; // Value 2 @ 2 line 4
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000110000000; // Value 2 @ 2 line 5
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000110000000; // Value 3 @ 2 line 1
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000100000000; // Value 3 @ 2 line 2
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000110000000; // Value 3 @ 2 line 3
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000100000000; // Value 3 @ 2 line 4
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000110000000; // Value 3 @ 2 line 5
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000010000000; // Value 4 @ 2 line 1
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000110000000; // Value 4 @ 2 line 2
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000110000000; // Value 4 @ 2 line 3
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000100000000; // Value 4 @ 2 line 4
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000100000000; // Value 4 @ 2 line 5
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000110000000; // Value 5 @ 2 line 1
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000010000000; // Value 5 @ 2 line 2
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000110000000; // Value 5 @ 2 line 3
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000100000000; // Value 5 @ 2 line 4
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000110000000; // Value 5 @ 2 line 5
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000110000000; // Value 6 @ 2 line 1
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000010000000; // Value 6 @ 2 line 2
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000110000000; // Value 6 @ 2 line 3
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000110000000; // Value 6 @ 2 line 4
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000110000000; // Value 6 @ 2 line 5
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000110000000; // Value 7 @ 2 line 1
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000100000000; // Value 7 @ 2 line 2
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000100000000; // Value 7 @ 2 line 3
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000100000000; // Value 7 @ 2 line 4
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000100000000; // Value 7 @ 2 line 5
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000110000000; // Value 8 @ 2 line 1
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000110000000; // Value 8 @ 2 line 2
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000110000000; // Value 8 @ 2 line 3
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000110000000; // Value 8 @ 2 line 4
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000110000000; // Value 8 @ 2 line 5
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000110000000; // Value 9 @ 2 line 1
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000110000000; // Value 9 @ 2 line 2
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000110000000; // Value 9 @ 2 line 3
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000100000000; // Value 9 @ 2 line 4
    dw   0b1111111001111111; // Mask @ x = 2
    dw   0b0000000100000000; // Value 9 @ 2 line 5
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0010000000000000; // Value 1 @ 3 line 1
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0010000000000000; // Value 1 @ 3 line 2
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0010000000000000; // Value 1 @ 3 line 3
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0010000000000000; // Value 1 @ 3 line 4
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0010000000000000; // Value 1 @ 3 line 5
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0011000000000000; // Value 2 @ 3 line 1
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0010000000000000; // Value 2 @ 3 line 2
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0011000000000000; // Value 2 @ 3 line 3
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0001000000000000; // Value 2 @ 3 line 4
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0011000000000000; // Value 2 @ 3 line 5
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0011000000000000; // Value 3 @ 3 line 1
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0010000000000000; // Value 3 @ 3 line 2
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0011000000000000; // Value 3 @ 3 line 3
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0010000000000000; // Value 3 @ 3 line 4
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0011000000000000; // Value 3 @ 3 line 5
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0001000000000000; // Value 4 @ 3 line 1
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0011000000000000; // Value 4 @ 3 line 2
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0011000000000000; // Value 4 @ 3 line 3
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0010000000000000; // Value 4 @ 3 line 4
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0010000000000000; // Value 4 @ 3 line 5
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0011000000000000; // Value 5 @ 3 line 1
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0001000000000000; // Value 5 @ 3 line 2
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0011000000000000; // Value 5 @ 3 line 3
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0010000000000000; // Value 5 @ 3 line 4
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0011000000000000; // Value 5 @ 3 line 5
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0011000000000000; // Value 6 @ 3 line 1
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0001000000000000; // Value 6 @ 3 line 2
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0011000000000000; // Value 6 @ 3 line 3
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0011000000000000; // Value 6 @ 3 line 4
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0011000000000000; // Value 6 @ 3 line 5
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0011000000000000; // Value 7 @ 3 line 1
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0010000000000000; // Value 7 @ 3 line 2
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0010000000000000; // Value 7 @ 3 line 3
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0010000000000000; // Value 7 @ 3 line 4
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0010000000000000; // Value 7 @ 3 line 5
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0011000000000000; // Value 8 @ 3 line 1
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0011000000000000; // Value 8 @ 3 line 2
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0011000000000000; // Value 8 @ 3 line 3
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0011000000000000; // Value 8 @ 3 line 4
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0011000000000000; // Value 8 @ 3 line 5
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0011000000000000; // Value 9 @ 3 line 1
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0011000000000000; // Value 9 @ 3 line 2
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0011000000000000; // Value 9 @ 3 line 3
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0010000000000000; // Value 9 @ 3 line 4
    dw   0b1100111111111111; // Mask @ x = 3
    dw   0b0010000000000000; // Value 9 @ 3 line 5
    // Middle of 'screen'
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000100000000; // Value 1 @ 4 line 1
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000100000000; // Value 1 @ 4 line 2
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000100000000; // Value 1 @ 4 line 3
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000100000000; // Value 1 @ 4 line 4
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000100000000; // Value 1 @ 4 line 5
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000110000000; // Value 2 @ 4 line 1
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000100000000; // Value 2 @ 4 line 2
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000110000000; // Value 2 @ 4 line 3
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000010000000; // Value 2 @ 4 line 4
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000110000000; // Value 2 @ 4 line 5
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000110000000; // Value 3 @ 4 line 1
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000100000000; // Value 3 @ 4 line 2
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000110000000; // Value 3 @ 4 line 3
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000100000000; // Value 3 @ 4 line 4
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000110000000; // Value 3 @ 4 line 5
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000010000000; // Value 4 @ 4 line 1
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000110000000; // Value 4 @ 4 line 2
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000110000000; // Value 4 @ 4 line 3
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000100000000; // Value 4 @ 4 line 4
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000100000000; // Value 4 @ 4 line 5
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000110000000; // Value 5 @ 4 line 1
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000010000000; // Value 5 @ 4 line 2
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000110000000; // Value 5 @ 4 line 3
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000100000000; // Value 5 @ 4 line 4
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000110000000; // Value 5 @ 4 line 5
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000110000000; // Value 6 @ 4 line 1
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000010000000; // Value 6 @ 4 line 2
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000110000000; // Value 6 @ 4 line 3
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000110000000; // Value 6 @ 4 line 4
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000110000000; // Value 6 @ 4 line 5
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000110000000; // Value 7 @ 4 line 1
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000100000000; // Value 7 @ 4 line 2
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000100000000; // Value 7 @ 4 line 3
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000100000000; // Value 7 @ 4 line 4
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000100000000; // Value 7 @ 4 line 5
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000110000000; // Value 8 @ 4 line 1
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000110000000; // Value 8 @ 4 line 2
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000110000000; // Value 8 @ 4 line 3
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000110000000; // Value 8 @ 4 line 4
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000110000000; // Value 8 @ 4 line 5
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000110000000; // Value 9 @ 4 line 1
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000110000000; // Value 9 @ 4 line 2
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000110000000; // Value 9 @ 4 line 3
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000100000000; // Value 9 @ 4 line 4
    dw   0b1111111001111111; // Mask @ x = 4
    dw   0b0000000100000000; // Value 9 @ 4 line 5
    // Right side of 'screen'
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001000; // Value 1 @ 5 line 1
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001000; // Value 1 @ 5 line 2
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001000; // Value 1 @ 5 line 3
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001000; // Value 1 @ 5 line 4
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001000; // Value 1 @ 5 line 5
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001100; // Value 2 @ 5 line 1
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001000; // Value 2 @ 5 line 2
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001100; // Value 2 @ 5 line 3
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000000100; // Value 2 @ 5 line 4
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001100; // Value 2 @ 5 line 5
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001100; // Value 3 @ 5 line 1
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001000; // Value 3 @ 5 line 2
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001100; // Value 3 @ 5 line 3
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001000; // Value 3 @ 5 line 4
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001100; // Value 3 @ 5 line 5
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000000100; // Value 4 @ 5 line 1
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001100; // Value 4 @ 5 line 2
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001100; // Value 4 @ 5 line 3
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001000; // Value 4 @ 5 line 4
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001000; // Value 4 @ 5 line 5
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001100; // Value 5 @ 5 line 1
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000000100; // Value 5 @ 5 line 2
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001100; // Value 5 @ 5 line 3
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001000; // Value 5 @ 5 line 4
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001100; // Value 5 @ 5 line 5
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001100; // Value 6 @ 5 line 1
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000000100; // Value 6 @ 5 line 2
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001100; // Value 6 @ 5 line 3
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001100; // Value 6 @ 5 line 4
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001100; // Value 6 @ 5 line 5
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001100; // Value 7 @ 5 line 1
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001000; // Value 7 @ 5 line 2
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001000; // Value 7 @ 5 line 3
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001000; // Value 7 @ 5 line 4
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001000; // Value 7 @ 5 line 5
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001100; // Value 8 @ 5 line 1
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001100; // Value 8 @ 5 line 2
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001100; // Value 8 @ 5 line 3
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001100; // Value 8 @ 5 line 4
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001100; // Value 8 @ 5 line 5
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001100; // Value 9 @ 5 line 1
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001100; // Value 9 @ 5 line 2
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001100; // Value 9 @ 5 line 3
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001000; // Value 9 @ 5 line 4
    dw   0b1111111111110011; // Mask @ x = 5
    dw   0b0000000000001000; // Value 9 @ 5 line 5
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000100000000; // Value 1 @ 6 line 1
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000100000000; // Value 1 @ 6 line 2
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000100000000; // Value 1 @ 6 line 3
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000100000000; // Value 1 @ 6 line 4
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000100000000; // Value 1 @ 6 line 5
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000110000000; // Value 2 @ 6 line 1
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000100000000; // Value 2 @ 6 line 2
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000110000000; // Value 2 @ 6 line 3
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000010000000; // Value 2 @ 6 line 4
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000110000000; // Value 2 @ 6 line 5
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000110000000; // Value 3 @ 6 line 1
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000100000000; // Value 3 @ 6 line 2
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000110000000; // Value 3 @ 6 line 3
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000100000000; // Value 3 @ 6 line 4
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000110000000; // Value 3 @ 6 line 5
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000010000000; // Value 4 @ 6 line 1
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000110000000; // Value 4 @ 6 line 2
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000110000000; // Value 4 @ 6 line 3
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000100000000; // Value 4 @ 6 line 4
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000100000000; // Value 4 @ 6 line 5
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000110000000; // Value 5 @ 6 line 1
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000010000000; // Value 5 @ 6 line 2
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000110000000; // Value 5 @ 6 line 3
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000100000000; // Value 5 @ 6 line 4
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000110000000; // Value 5 @ 6 line 5
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000110000000; // Value 6 @ 6 line 1
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000010000000; // Value 6 @ 6 line 2
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000110000000; // Value 6 @ 6 line 3
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000110000000; // Value 6 @ 6 line 4
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000110000000; // Value 6 @ 6 line 5
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000110000000; // Value 7 @ 6 line 1
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000100000000; // Value 7 @ 6 line 2
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000100000000; // Value 7 @ 6 line 3
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000100000000; // Value 7 @ 6 line 4
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000100000000; // Value 7 @ 6 line 5
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000110000000; // Value 8 @ 6 line 1
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000110000000; // Value 8 @ 6 line 2
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000110000000; // Value 8 @ 6 line 3
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000110000000; // Value 8 @ 6 line 4
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000110000000; // Value 8 @ 6 line 5
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000110000000; // Value 9 @ 6 line 1
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000110000000; // Value 9 @ 6 line 2
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000110000000; // Value 9 @ 6 line 3
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000100000000; // Value 9 @ 6 line 4
    dw   0b1111111001111111; // Mask @ x = 6
    dw   0b0000000100000000; // Value 9 @ 6 line 5
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000100000000000; // Value 1 @ 7 line 1
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000100000000000; // Value 1 @ 7 line 2
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000100000000000; // Value 1 @ 7 line 3
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000100000000000; // Value 1 @ 7 line 4
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000100000000000; // Value 1 @ 7 line 5
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000110000000000; // Value 2 @ 7 line 1
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000100000000000; // Value 2 @ 7 line 2
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000110000000000; // Value 2 @ 7 line 3
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000010000000000; // Value 2 @ 7 line 4
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000110000000000; // Value 2 @ 7 line 5
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000110000000000; // Value 3 @ 7 line 1
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000100000000000; // Value 3 @ 7 line 2
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000110000000000; // Value 3 @ 7 line 3
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000100000000000; // Value 3 @ 7 line 4
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000110000000000; // Value 3 @ 7 line 5
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000010000000000; // Value 4 @ 7 line 1
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000110000000000; // Value 4 @ 7 line 2
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000110000000000; // Value 4 @ 7 line 3
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000100000000000; // Value 4 @ 7 line 4
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000100000000000; // Value 4 @ 7 line 5
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000110000000000; // Value 5 @ 7 line 1
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000010000000000; // Value 5 @ 7 line 2
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000110000000000; // Value 5 @ 7 line 3
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000100000000000; // Value 5 @ 7 line 4
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000110000000000; // Value 5 @ 7 line 5
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000110000000000; // Value 6 @ 7 line 1
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000010000000000; // Value 6 @ 7 line 2
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000110000000000; // Value 6 @ 7 line 3
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000110000000000; // Value 6 @ 7 line 4
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000110000000000; // Value 6 @ 7 line 5
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000110000000000; // Value 7 @ 7 line 1
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000100000000000; // Value 7 @ 7 line 2
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000100000000000; // Value 7 @ 7 line 3
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000100000000000; // Value 7 @ 7 line 4
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000100000000000; // Value 7 @ 7 line 5
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000110000000000; // Value 8 @ 7 line 1
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000110000000000; // Value 8 @ 7 line 2
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000110000000000; // Value 8 @ 7 line 3
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000110000000000; // Value 8 @ 7 line 4
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000110000000000; // Value 8 @ 7 line 5
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000110000000000; // Value 9 @ 7 line 1
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000110000000000; // Value 9 @ 7 line 2
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000110000000000; // Value 9 @ 7 line 3
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000100000000000; // Value 9 @ 7 line 4
    dw   0b1111001111111111; // Mask @ x = 7
    dw   0b0000100000000000; // Value 9 @ 7 line 5
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0100000000000000; // Value 1 @ 8 line 1
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0100000000000000; // Value 1 @ 8 line 2
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0100000000000000; // Value 1 @ 8 line 3
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0100000000000000; // Value 1 @ 8 line 4
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0100000000000000; // Value 1 @ 8 line 5
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0110000000000000; // Value 2 @ 8 line 1
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0100000000000000; // Value 2 @ 8 line 2
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0110000000000000; // Value 2 @ 8 line 3
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0010000000000000; // Value 2 @ 8 line 4
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0110000000000000; // Value 2 @ 8 line 5
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0110000000000000; // Value 3 @ 8 line 1
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0100000000000000; // Value 3 @ 8 line 2
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0110000000000000; // Value 3 @ 8 line 3
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0100000000000000; // Value 3 @ 8 line 4
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0110000000000000; // Value 3 @ 8 line 5
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0010000000000000; // Value 4 @ 8 line 1
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0110000000000000; // Value 4 @ 8 line 2
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0110000000000000; // Value 4 @ 8 line 3
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0100000000000000; // Value 4 @ 8 line 4
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0100000000000000; // Value 4 @ 8 line 5
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0110000000000000; // Value 5 @ 8 line 1
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0010000000000000; // Value 5 @ 8 line 2
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0110000000000000; // Value 5 @ 8 line 3
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0100000000000000; // Value 5 @ 8 line 4
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0110000000000000; // Value 5 @ 8 line 5
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0110000000000000; // Value 6 @ 8 line 1
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0010000000000000; // Value 6 @ 8 line 2
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0110000000000000; // Value 6 @ 8 line 3
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0110000000000000; // Value 6 @ 8 line 4
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0110000000000000; // Value 6 @ 8 line 5
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0110000000000000; // Value 7 @ 8 line 1
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0100000000000000; // Value 7 @ 8 line 2
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0100000000000000; // Value 7 @ 8 line 3
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0100000000000000; // Value 7 @ 8 line 4
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0100000000000000; // Value 7 @ 8 line 5
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0110000000000000; // Value 8 @ 8 line 1
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0110000000000000; // Value 8 @ 8 line 2
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0110000000000000; // Value 8 @ 8 line 3
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0110000000000000; // Value 8 @ 8 line 4
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0110000000000000; // Value 8 @ 8 line 5
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0110000000000000; // Value 9 @ 8 line 1
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0110000000000000; // Value 9 @ 8 line 2
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0110000000000000; // Value 9 @ 8 line 3
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0100000000000000; // Value 9 @ 8 line 4
    dw   0b1001111111111111; // Mask @ x = 8
    dw   0b0100000000000000; // Value 9 @ 8 line 5