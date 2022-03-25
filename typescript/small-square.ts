
import type Square from "./square.ts";

export default class SmallSquare implements Square {

    public constructor(dimension: number) {

        if (dimension < 0 || dimension > 31) {

            throw new Error(`Unsupported dimension ${dimension}`);
        }

        this.bits = (1 << dimension) - 1;
    }

    public clone(): Square {

        return Object.setPrototypeOf({ bits: this.bits },
                                     SmallSquare.prototype);
    }

    public hasPossibility(value: number): boolean {

        return (this.bits & toMask(value)) !== 0;
    }

    public removePossibility(value: number): number {

        this.bits &= ~toMask(value);

        return this.possibilityCount;
    }

    public get possibilityCount(): number {

        let count = 0;

        for (let bits = this.bits; bits; ++count) {

            bits &= bits - 1;
        }

        return count;
    }

    public get value(): number {

        if (this.possibilityCount !== 1) return 0;

        let value = 1;

        for (let mask = 1; value < 31; mask <<= 1) {

            if ((this.bits & mask) !== 0) return value;

            ++value;
        }

        return value;
    }

    public set value(value: number) {

        this.bits = toMask(value);
    }

    private bits: number;
}

const toMask = (value: number): number => 1 << (value - 1);