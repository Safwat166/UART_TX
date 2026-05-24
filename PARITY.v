module PARITY (
	input	wire	[7:0]	P_DATA     ,
	input	wire			DATA_VALID ,
	input	wire			PAR_TYP    ,
	input	wire			CLK		   ,
	input	wire			RST		   ,
	
	output	reg				PAR_BIT  
);

	always @ (posedge CLK or negedge RST)
	begin
		if(!RST)
		begin
			PAR_BIT <= 1'b1 ;
		end
		else if(DATA_VALID)
		begin
			if((PAR_TYP) && (^P_DATA == 1'b1))
			begin
				PAR_BIT <= 1'b0 ;
			end
			
			else if((PAR_TYP) && (^P_DATA == 1'b0))
			begin
				PAR_BIT <= 1'b1 ;
			end
			
			else if((!PAR_TYP) && (^P_DATA == 1'b1))
			begin
				PAR_BIT <= 1'b1 ;
			end
			
			else if((!PAR_TYP) && (^P_DATA == 1'b0))
			begin
				PAR_BIT <= 1'b0 ;
			end
		end
	end
endmodule