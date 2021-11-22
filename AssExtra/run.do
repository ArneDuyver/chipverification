## to start in terminal: vsim -c -do run.do
#do compile.do
# vsim -do dofile.do
vsim -c -voptargs="+acc" top
run -all


