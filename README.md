# armcpu

Resources: [18-447 CMU Introduction to Computer Architecture Labs](http://www.ece.cmu.edu/~ece447/s14/doku.php?id=labs)

## Test-bench Instructions (todo)

The test-bench takes in an ARM assembly file as input via Makefile arguments and outputs a register dump and a waveform file. 

## Directory Structure

* `include/` - Contains individual modules instantiated by top-level module; they should not be instantiated by each other. Some of the more important modules:
    * `arm_decode.v` - Passes appropriate control signals to the ALU, MAC, multiple multiplexers in the path, according to the instruction; meat of the datapath
    * `barrel_shifter.v` - Does arithmetic and logical shifts combinatorially
    * `arm_memory.v` - Does asychronous reads and synchronous writes to memory; dual-ported, big-endian
    * `cond_decode.v` - Checks for CPSR condition validity
    * `arm_alu.v` - Does appropriate arithmetic op on input operands depending on select lines
* `arm_core.v` - Top-level module for instantiating all individual components in `include/`; test-bench will be run on this

Various muxes will have to be instantiated between each module for selecting operands, etc.

### Workflow

Chepo'd from the Telegram message.

Idea of implementing different operations is (mote daag mein of course):
1. Check if required modules for making the operation work exist in the circuit
2. If not, instantiate module(s) in top-level module and wire appropriately
3. If they exist and any input(s) to the module(s) clash with another op (for ex. in `barrel_shifter`, an input could be a register value or an immediate value), you stuff in a mux to appropriately select the input depending on what your op is
4. Generate control signals for the mux(es) and the ALU in the `arm_decode` module for your op

1. Small feature gets assigned to a person after group meeting
2. The person implements it in a separate branch and then sends PR to master
3. The PR needs review by maintainer of module within 12hrs, and if okayed by them, can be merged into master
4. If no reply on PR till 12hrs hours by maintainer, anyone can review it, and if no reply till 24hrs more, it can be merged into master
5. PR should have no merge conflicts, it's responsibility of the PR-sender to keep their branch updated to master

### Maintainers

shell/sim: darkapex
verilog: kharghoshal
