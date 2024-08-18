import cocotb
from cocotb.triggers import RisingEdge, ClockCycles 
from cocotb.clock import Clock


@cocotb.test()
async def test_3x3_single_digit(dut):
    cocotb.start_soon(Clock(dut.i_clk, 12, "ns").start())

    await ClockCycles(dut.i_clk, 3)

    dut.i_a.value = [
        1, 2, 3,
        5, 4, 3,
        3, 0, 8,
    ]

    dut.i_b.value = [
        5, 8, 0,
        1, 2, 3,
        1, 0, 4,
    ]

    dut.i_trigger.value = 1

    await RisingEdge(dut.o_ready)
    await ClockCycles(dut.i_clk, 3)

    print("Edge: ", dut.o_ready.value)
    for i in range(0, 9):
        print(int(bin(dut.o_result.value[i]), 2), end=(" " if (i + 1) % 3 != 0 else "\n"))
