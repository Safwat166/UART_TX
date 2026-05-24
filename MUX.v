module MUX (
	input	wire	[1:0]	MUX_SEL  ,
	input	wire			SER_DATA ,		
	input	wire			PAR_BIT  ,
	input	wire			CLK      ,
	
	output	reg				TX_OUT
);

	always @ (posedge CLK)
	begin
		case(MUX_SEL)
		2'b00 : TX_OUT <= 1'b0     ;
		2'b01 : TX_OUT <= 1'b1     ;
		2'b10 : TX_OUT <= SER_DATA ;
		2'b11 : TX_OUT <= PAR_BIT  ;
		endcase
	end
	
endmodule