
import type { Square, ReadOnlySquare } from "./square.ts";

import SmallSquare from "./small-square.ts";

import { newArray } from "./array.ts";

// TODO: Maybe have another layer that also adds
//       validation? Maybe a ReadOnlyGrid?

export default class Grid {

    public constructor(dimension: number) {

        this.dimension         = dimension;
        this.impossibleSquares = 0;
        this.incompleteSquares = this.dimension * this.dimension;

        const square = new SmallSquare(this.dimension);

        this.squares = newArray(
            this.dimension,
            () => newArray(this.dimension, () => square.clone()));
    }

    public readonly dimension: number;

    public clone(): Grid {

        const squaresClone = this.squares.map(r => r.map(s => s.clone()));

        return Object.setPrototypeOf({ ... this, squares: squaresClone },
                                     Grid.prototype);
    }

    public getSquare(x: number, y: number): ReadOnlySquare {

        return this.squares[x][y];
    }

    public setValue(x: number, y: number, value: number): void {

        const square = this.squares[x][y];

        switch (square.possibilityCount) {
            case 0:  this.impossibleSquares -= 1; break;
            case 1:  break;
            default: this.incompleteSquares -= 1; break;
        }

        square.value = value;
    }

    public removePossibility(x: number, y: number, value: number): boolean {

        if (!this.squares[x][y].removePossibility(value)) return false;

        switch (this.squares[x][y].possibilityCount) {
            case 0: {
                this.impossibleSquares += 1;
                this.incompleteSquares += 1;
                break;
            }
            case 1: this.incompleteSquares -= 1; break;
        }

        return true;
    }

    public get isPossible(): boolean { return 0 === this.impossibleSquares; }

    public get isComplete(): boolean { return 0 === this.incompleteSquares; }

    private readonly squares: Square[][];

    private impossibleSquares: number;

    private incompleteSquares: number;
}