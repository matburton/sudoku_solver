
#pragma once

#include "sudoku_scripting_lib/types.hpp"

/// \brief The index of each solution returned
///        matches that of the related input puzzle
///
SudokuScriptingLib::PuzzlesT batchSolve
   (const SudokuScriptingLib::PuzzlesT& rPuzzles);