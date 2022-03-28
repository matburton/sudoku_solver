
import Grid from "./grid.ts";

import { toGridString } from "./serialisation.ts";

const grid = new Grid(3);

grid.setSquareValue(0, 0, 1);
grid.setSquareValue(0, 1, 1);

console.log(toGridString(grid));

Deno.exit(0);