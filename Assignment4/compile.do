vlib work
vcom alu.vhd gbprocessor.vhd
vlog -sv gbModel.sv
vlog -sv GB_iface.sv transaction_mon.sv machinecode_instruction.sv generator.sv driver.sv checker.sv scoreboard.sv monitor.sv environment.sv test.sv top.sv