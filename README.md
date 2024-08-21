Matrix multiplication on icesugar fpga.

---

**Data flow**:
1. data comes in via uart, goes into `mat_buff` (via mat_cells) (8 bits wide, 9 deep)
2. mat_buff is used to redirect (via mat_in) the matrices into different matrix buffers based on a state variable.
3. mat_a, mat_b are passed into the multiplier, the comp is triggered using `trigger`.
4. Result is passed into `tx_buff` via `mat_out`. Output of this buffer is controlled by a ptr,
   which can be advanced using `i_next`.
5. The ptr is signalled using a feedback loop from the tx, which signals busy-ness using ledr.
