#!/bash/bin

vlib work
vcom alu.vhd
vlog -sv ALU_iface.sv top.sv

echo "Press a key to continue"
read dummy_variable
## vsim gui doesn't seem to start in bash in windows, so I commented out the next line.
#vsim top