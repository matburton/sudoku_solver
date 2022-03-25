
import Square from "./square.ts";

let square = new Square(9).clone();

square.removePossibility(5);

square = square.clone();

console.log(square.possibilityCount);

Deno.exit(0);