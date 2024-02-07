simu: build/FifoSync.vcd
	
build/FifoSync.vvp: FifoSync.sv FifoSync.tb.sv
	iverilog -g 2012 -o $@ $^

build/FifoSync.vcd: build/FifoSync.vvp
	vvp $^ > build/FifoSync.log
