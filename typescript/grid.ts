
import type Square from "./square.ts";

import SmallSquare from "./small-square.ts";

import { newArray } from "./array.ts";

export default class Grid {

    public constructor(sectorDimension: number) {

        this.sectorDimension   = sectorDimension;
        this.dimension         = sectorDimension * sectorDimension;
        this.impossibleSquares = 0;
        this.incompleteSquares = this.dimension * this.dimension;

        const square = new SmallSquare(this.dimension);

        this.squares = newArray(
            this.dimension,
            () => newArray(this.dimension, () => square.clone()));
    }

    public readonly sectorDimension: number;

    public readonly dimension: number;

    public clone(): Grid {

        const squaresClone = this.squares.map(r => r.map(s => s.clone()));

        return Object.setPrototypeOf({ ... this, squares: squaresClone },
                                     Grid.prototype);
    }

    public getSquareClone(x: number, y: number): Square {

        return this.squares[x][y].clone();
    }

    public setSquareValue(x: number, y: number, value: number): void {

        const square = this.squares[x][y];

        switch (square.possibilityCount) {
            case 0:  this.impossibleSquares -= 1; break;
            case 1:  break;
            default: this.incompleteSquares -= 1; break;
        }

        square.value = value;
    }

    public removeSquarePossibility(x: number, y: number, value: number): void {

        switch (this.squares[x][y].removePossibility(value)) {
            case 0: {
                this.impossibleSquares += 1;
                this.incompleteSquares += 1;
                break;
            }
            case 1: this.incompleteSquares -= 1; break;
        }
    }

    public get isPossible(): boolean { return 0 === this.impossibleSquares; }

    public get isComplete(): boolean { return 0 === this.incompleteSquares; }

    private readonly squares: Square[][];

    private impossibleSquares: number;

    private incompleteSquares: number;
}