module UART_TX_TOP (
	input	wire	[7:0]	p_data     , 
	input	wire			clk        ,
	input	wire			rst        ,
	input	wire			data_valid ,
	input	wire			par_typ    ,
	input	wire			par_en     ,
	
	output	wire			tx_out     ,
	output	wire			busy       
);
	
	wire [1:0]	mux_sel  ;
	wire		ser_en   ;
	wire		ser_done ;
	wire 		ser_data ;
	wire 		par_bit  ;
	
	//fsm instantiation
	FSM F1 (
	.DATA_VALID(data_valid) ,
	.PAR_EN(par_en)         ,
	.SER_DONE(ser_done)     ,
	.CLK(clk)               ,
	.RST(rst)				,
	.MUX_SEL(mux_sel)       ,
	.SER_EN(ser_en)         ,
	.BUSY(busy)
	);
	
	//serializer instantiation
	SERIALIZER S1 (
	.P_DATA(p_data)     ,
	.SER_EN(ser_en)     ,
	.CLK(clk)           ,
	.RST(rst)		    ,
	.SER_DONE(ser_done) ,
	.SER_DATA(ser_data) 
	);
	
	//MUX	instantiation
	MUX M1 (
	.MUX_SEL(mux_sel)   ,
	.SER_DATA(ser_data) ,
	.PAR_BIT(par_bit)   ,
	.CLK(clk)           ,
	.TX_OUT(tx_out)
	);
	
	//PARITY instantiation
	PARITY P1(
	.P_DATA(p_data)         , 
	.DATA_VALID(data_valid) ,
	.PAR_TYP(par_typ)       ,
	.CLK(clk)               ,
	.RST(rst)				,
	.PAR_BIT(par_bit)
	);
endmodule