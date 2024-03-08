quietly WaveActivateNextPane {} 0
add wave -r /tb_top/*
add wave -noupdate /tb_top/dut/*
add dataflow -noupdate /tb_top/dut/*
add list /tb_top/dut/*
add memory /tb_top/dut/*
add watch /tb_top/dut/*
update
WaveRestoreZoom {0 ps} {1549120 ps}
