module FSM (
	
	input				DATA_VALID ,
	input				PAR_EN     ,
	input				SER_DONE   ,
	input				CLK        ,
	input 				RST        ,
	
	output	reg [1:0]	MUX_SEL    ,
	output	reg			SER_EN     ,
	output	reg			BUSY       

);
	reg					BUSY_COMP ;

//parameters of the states 
typedef enum bit [3:0] {
	IDLE	=	4'b0000,
	START	=	4'b0001,
	DATA	=	4'b0010,
	PARITY	=	4'b0100,
	STOP	=	4'b1000
}state_e;

state_e current_state ,next_state ;
					
	always @ (posedge CLK or negedge RST)
	begin
		if(!RST)
		begin
			current_state <= IDLE ;
		end
		
		else
		begin
			current_state <= next_state ;
		end
	end
	
	//next state logic & output logic
	
	always @ (*)
	begin
	BUSY_COMP = 1'b0  ;
	SER_EN    = 1'b0  ;
	MUX_SEL   = 2'b01 ; //this selection represents the stop bit and the idle state too because they both have same values which is equal to 1
		case(current_state)
		
		IDLE : begin
					if(DATA_VALID)
					begin
						next_state = START ;
					end
					
					else
					begin
						next_state = IDLE ;
					end
			    end
				
		//start bit		
		START	  : begin
					SER_EN     = 2'b1  ;
					MUX_SEL    = 2'b00 ; 
					BUSY_COMP  = 1'b1  ;
					next_state = DATA    ;
				end
				
		//data transmission		
		DATA 	  : begin
					SER_EN    = 1'b1  ;
					MUX_SEL   = 2'b10 ;
					BUSY_COMP = 1'b1  ;
					if(SER_DONE && PAR_EN)
					begin
						next_state = PARITY ; 
					end
					
					else if(SER_DONE && !PAR_EN)
					begin
						next_state = STOP ;
					end
					
					else
					begin
						next_state = DATA ;
					end
				end
				
		//parity bit		
		PARITY	  : begin
					SER_EN    = 1'b1  ;
					MUX_SEL    = 2'b11 ;
					BUSY_COMP  = 1'b1  ;
					next_state = STOP    ;
				end
		
		//stop bit
		STOP	  : begin
					SER_EN    = 1'b1  ;
					MUX_SEL    = 2'b01 ;
					BUSY_COMP  = 1'b1  ;
					next_state = IDLE  ;
				end
				
		default : begin
					next_state = IDLE    ;
					BUSY_COMP  = 1'b0    ;
					SER_EN     = 1'b0    ;
					MUX_SEL    = 2'b01   ;
				  end
		endcase
		
	end
	
	//sequential logic for the busy flag
	always @ (posedge CLK)
	begin
		BUSY <= BUSY_COMP ;
	end
endmodule