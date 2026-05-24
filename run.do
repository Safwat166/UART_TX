vlib work
vlog *.*v
vsim -voptargs=+acc work.UART_TX_TB
do wave.do
run -all