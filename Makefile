IV = iverilog
BUILDDIR = build
IDIR = include
ROOT = arm_core # this will eventually become the test-bench file
IV_FLAGS = -Wall -I $(IDIR) -s $(ROOT).sv
MODULE_LIST = module_list.txt

.PHONY: compile assemble sim tb batch-sim all clean

all: compile # for now, tb later

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

# Compile Verilog
compile: $(BUILDDIR)
	$(IV) $(IV_FLAGS) -o $(BUILDDIR)/$(ROOT)

# Assemble ARM Assembly Input
assemble:

# Simulate Verilog
sim: compile assemble
	vvp $(BUILDDIR)/$(ROOT)

# Run test-bench
tb: compile

# Run test-bench in batch-mode
batch-sim: compile

clean: 
	-rm -rf $(BUILDDIR)

# Synthesize Verilog to check for time contraints
# Need to figure how to do this with verilator
#synth:
