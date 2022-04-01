
import SudokuGrid from "./sudoku-grid.ts";

import { toGridString } from "./serialisation.ts";

import DoubleLinkedList from "./double-linked-list.ts";

const grid = new SudokuGrid(3);

grid.setValue(0, 0, 1);
grid.setValue(0, 1, 1);

console.log(toGridString(grid));