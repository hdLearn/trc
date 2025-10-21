all : alu cache

alu :
	yosys -m ghdl -p "ghdl --std=08 alu.vhd -e alu; synth_ice40 -json alu.json" 
	nextpnr-ice40 --hx8k --json alu.json --pcf-allow-unconstrained --asc alu.asc --freq 50 

cache :
	ghdl -a --std=08 package.vhd cache.vhd
	ghdl -e --std=08 cache
	yosys -m ghdl -p "ghdl --std=08 package.vhd cache.vhd -e cache; synth_ice40 -json cache.json" 
	nextpnr-ice40 --hx8k --json cache.json --pcf-allow-unconstrained --asc cache.asc --freq 50

.PHONY : all alu cache