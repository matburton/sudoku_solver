
export default interface Square {

    clone(): Square;

    hasPossibility(value: number): boolean;

    removePossibility(value: number): void;

    get possibilityCount(): number;

    get value(): number;

    set value(value: number);
}