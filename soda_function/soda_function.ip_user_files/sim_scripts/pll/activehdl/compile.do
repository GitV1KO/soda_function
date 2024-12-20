vlib work
vlib activehdl

vlib activehdl/xpm
vlib activehdl/xil_defaultlib

vmap xpm activehdl/xpm
vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xpm  -sv2k12 "+incdir+../../../ipstatic" \
"F:/ElectronicWork/Software/vivado2019.2/Vivado/2019.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93 \
"F:/ElectronicWork/Software/vivado2019.2/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic" \
"../../../../soda_function.srcs/sources_1/ip/pll/pll_clk_wiz.v" \
"../../../../soda_function.srcs/sources_1/ip/pll/pll.v" \

vlog -work xil_defaultlib \
"glbl.v"

