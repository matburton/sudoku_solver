
import Grid from "./grid.ts";

import { newArray } from "./array.ts";

function character(base: string, offset: number): string {

    return String.fromCharCode(base.charCodeAt(0) + offset);
}

function toCharacter(grid: Grid, x: number, y: number): string {

    const value = grid.getSquareClone(x, y).value;

    if (value === 0) return ".";

    if (grid.sectorDimension <= 3) return character("0", value);

    if (value < 11)   return character("0", value - 1);
    if (value < 37)   return character("A", value - 11);
    if (value < 63)   return character("a", value - 37);
    if (value === 63) return "$";

    return "@";
}

function insertEvery<T>(array: T[], value: number, item: T): void {

    for (let index = array.length - value; index > 0; index -= value) {
        
        array.splice(index, 0, item);
    }
}

function toRowString(grid: Grid, y: number): string {

    const characters = newArray(grid.dimension,
                                x => toCharacter(grid, x, y));

    insertEvery(characters, grid.sectorDimension, "|");

    return characters.join(" ");
}

export function toGridString(grid: Grid): string {

    const sectorLine = "-".repeat(grid.sectorDimension * 2 - 1);
    
    const dividerLine =
        newArray(grid.sectorDimension, () => sectorLine).join("-+-");

    const lines = newArray(grid.dimension, y => toRowString(grid, y));

    insertEvery(lines, grid.sectorDimension, dividerLine);

    return lines.join("\r\n");
}