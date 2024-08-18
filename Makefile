# Sim
SIM ?= verilator
TOPLEVEL_LANG ?= verilog
# EXTRA_ARGS += --trace --trace-structs

# Sources
VERILOG_SOURCES += $(PWD)/matmul.v
TOPLEVEL = matmul
MODULE = test_matmul

include $(shell cocotb-config --makefiles)/Makefile.sim
