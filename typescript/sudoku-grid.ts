
import Grid from "./grid.ts";

export default class SudokuGrid extends Grid {

    public constructor(sectorDimension: number) {

        super(sectorDimension * sectorDimension);

        this.sectorDimension = sectorDimension;
    }

    public clone(): SudokuGrid {

        return Object.setPrototypeOf(super.clone(), SudokuGrid.prototype);
    }

    public setValue(x: number, y: number, value: number): void {

        super.setValue(x, y, value);

        this.removeRelatedPossibilities(x, y, value);
    }

    public removePossibility(x: number, y: number, value: number): boolean {

        if (!super.removePossibility(x, y, value)) return false;

        value = this.getSquare(x, y).value;

        if (value !== 0) this.removeRelatedPossibilities(x, y, value);

        return true;
    }

    private removeRelatedPossibilities(x: number, y: number, value: number): void {

        for (let indexX = 0; indexX < this.dimension; ++indexX) {

            if (indexX !== x) this.removePossibility(indexX, y, value);
        }
    
        for (let indexY = 0; indexY < this.dimension; ++indexY) {
    
            if (indexY !== y) this.removePossibility(x, indexY, value);
        }
    
        const startX = this.getSectorStart(x);
        const startY = this.getSectorStart(y);
    
        const endX = startX + this.sectorDimension;
        const endY = startY + this.sectorDimension;
    
        for (let indexY = startY; indexY < endY; ++indexY) {
    
            for (let indexX = startX; indexX < endX; ++indexX) {
    
                if (indexX !== x && indexY !== y) {
    
                    this.removePossibility(indexX, indexY, value);
                }
            }
        }
    }

    private getSectorStart(index: number): number {
     
        return (index / this.sectorDimension | 0) * this.sectorDimension;
    }

    public readonly sectorDimension: number;
}