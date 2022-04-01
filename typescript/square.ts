
interface ReadOnlySquare {

    clone(): Square;

    hasPossibility(value: number): boolean;

    get possibilityCount(): number;

    get value(): number;
}

export default interface Square extends ReadOnlySquare {

    removePossibility(value: number): boolean;

    set value(value: number);
}

export type { Square, ReadOnlySquare };