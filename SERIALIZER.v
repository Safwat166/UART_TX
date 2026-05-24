module SERIALIZER (
	input	wire [7:0]  P_DATA     ,
	input	wire		SER_EN     ,
	input   wire   	 	CLK        ,
	input	wire		RST        ,
	
	output	reg			SER_DONE   ,
	output	reg			SER_DATA
);

	reg		[7:0]	FFs         ;
	reg		[2:0]	counter     ;
	wire			counter_max ;
	
	//sequential logic
	always @ (posedge CLK or negedge RST)
	begin

		if(!RST) //this reset will get me to the idle state and store in the ffs zeros
		begin
			FFs <= 8'b0      ;
			counter <= 3'd0  ;
			SER_DONE <= 1'b0 ;
		end
	
		else if(SER_EN)   //once seriel enable get high it will start transmite the data
		begin			
			if(!counter_max)
			begin
				{FFs[6:0],SER_DATA} <= FFs ;
				counter <= counter + 1'b1  ;
			end
				
			else
			begin
				SER_DATA <= FFs[0] ;
				SER_DONE <= 1'b1   ; 
			end
		end
		
		else
		begin
			FFs <= P_DATA    ;
			SER_DONE <= 1'b0 ;
			counter <= 3'd0  ;
		end
	end
	
	//max count flag
	assign counter_max = (counter == 3'd7) ;
	
	/* important note :
	
		- i made the (counter == 7) because i wanted the ser_done to be high at last bit i transmit and i wanted
		it to last for one clock cycle (waiting for next state) but the problem when making (counter == 7) not (counter == 8)
		that the MSB didn't shift so i shifted it when ser_done is high. also less interations :)
		
		- if i made (counter == 8) so the MSB will last on the output for 2 clock cycles wainting for the next state
		
	*/
	
endmodule