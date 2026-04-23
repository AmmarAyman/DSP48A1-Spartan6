vlib work
vlog GRMU.v add_sub.v Top.v DSP_tb.v
vsim -voptargs=+acc work.DSP_tb
add wave *
run -all
