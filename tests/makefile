SRC = ../rtl/alu # VHDL sources files
STB = tb_alu # Sources for test bench
SRC_E = $(SRC:=.vhd)
STB_E = $(STB:=.vhd)
VCD_E = $(STB:=.vcd)
VERSION = --std=08

all: elaborate

analyse: $(SRC_E) $(STB_E)
	ghdl -a $(VERSION) $(SRC_E) $(STB_E)

elaborate: analyse
	@for tb in $(STB); do \
		ghdl -e $(VERSION) $$tb; \
	done

run: elaborate
	@for tb in $(STB); do \
		ghdl -r $(VERSION) $$tb; \
	done 

gtkwave: elaborate
	@for tb in $(STB); do \
		ghdl -r $(VERSION) $$tb --vcd=$$tb.vcd; \
	done

clean:
	rm -f $(VCD_E)

.PHONY: all clean gtkwave analyse elaborate run