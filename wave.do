onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {test bench signals} -color {Slate Blue} /UART_TX_TB/clk_tb
add wave -noupdate -expand -group {test bench signals} /UART_TX_TB/rst_tb
add wave -noupdate -expand -group {test bench signals} /UART_TX_TB/p_data_tb
add wave -noupdate -expand -group {test bench signals} -color Goldenrod /UART_TX_TB/data_valid_tb
add wave -noupdate -expand -group {test bench signals} -color {Violet Red} /UART_TX_TB/tx_out_tb
add wave -noupdate -expand -group {test bench signals} -color {Sky Blue} /UART_TX_TB/busy_tb
add wave -noupdate -expand -group {test bench signals} /UART_TX_TB/par_typ_tb
add wave -noupdate -expand -group {test bench signals} /UART_TX_TB/par_en_tb
add wave -noupdate -expand -group {test bench signals} /UART_TX_TB/read_check_data/expected
add wave -noupdate -expand -group {test bench signals} -color Thistle /UART_TX_TB/read_check_data/stored_output
add wave -noupdate -expand -group {internal signals of top} /UART_TX_TB/DUT/mux_sel
add wave -noupdate -expand -group {internal signals of top} /UART_TX_TB/DUT/ser_en
add wave -noupdate -expand -group {internal signals of top} /UART_TX_TB/DUT/ser_done
add wave -noupdate -expand -group {internal signals of top} /UART_TX_TB/DUT/ser_data
add wave -noupdate -expand -group {internal signals of top} -color Blue /UART_TX_TB/DUT/par_bit
add wave -noupdate -expand -group {fsm signals} -color Gold /UART_TX_TB/DUT/F1/current_state
add wave -noupdate -expand -group {fsm signals} -color Gold /UART_TX_TB/DUT/F1/next_state
add wave -noupdate -expand -group {serializer signals} /UART_TX_TB/DUT/S1/FFs
add wave -noupdate -expand -group {serializer signals} /UART_TX_TB/DUT/S1/counter
add wave -noupdate -expand -group {serializer signals} /UART_TX_TB/DUT/S1/counter_max
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {34311 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {183671 ps}
