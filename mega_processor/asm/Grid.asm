
Grid_gridByteSize:
        ld.w r1, #326;
        ret;
        
possibilityValueMasks:
        dw   0b000000000;
        dw   0b000000001;
        dw   0b000000010;
        dw   0b000000100;
        dw   0b000001000;
        dw   0b000010000;
        dw   0b000100000;
        dw   0b001000000;
        dw   0b010000000;
        dw   0b100000000;

Grid_toMask:
        ld.w r3, #possibilityValueMasks;
        add  r3, r1;
        add  r3, r1;
        ld.w r1, (r3);
        ret;