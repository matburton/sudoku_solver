
import SmallSquare from "./small-square.ts";

let square = new SmallSquare(9).clone();

square.removePossibility(5);

square = square.clone();

console.log(square.possibilityCount);

Deno.exit(0);