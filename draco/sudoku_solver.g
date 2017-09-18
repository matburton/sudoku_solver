
type Counters_t = struct
{
    ulong c_StartTime;
    ulong c_GridSplits;
    ulong c_ImpossibleGrids;
    ulong c_GridsLost;
    ulong c_Solutions;
};

extern setValueAt(*Grid_t pGrid; uint x, y, value) void;

extern freeFrontGrid(*Grid_t pGridList) *Grid_t;

extern freeGridList(*Grid_t pGridList) void;

extern breakSignaled() bool;

/* Returns nil if there are no more solutions */
/* Caller must free front grid if complete before re-calling */
extern advanceSolving(*Grid_t pGridList; *Counters_t pCounters) *Grid_t;

extern writeCounters(channel output text target; *Counters_t pCounters) void;