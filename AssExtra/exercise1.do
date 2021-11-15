#to start in terminal: vsim -c -do exercise1.do
vlib work

vlog -sv exercise1.sv
vsim -c -voptargs="+acc" test
run -all
