`timescale 1ns/1ps
module UART_TX_TB();
	reg		[7:0]	p_data_tb     ;
	reg				clk_tb   	  ;
	reg				rst_tb		  ;
	reg				data_valid_tb ;
	reg				par_typ_tb    ;
	reg				par_en_tb     ;
	
	wire			tx_out_tb     ;
	wire			busy_tb		  ;
	
////////////////////////////////////////////////////////////
////////////////////// DUT Signals ////////////////////////
//////////////////////////////////////////////////////////

	UART_TX_TOP DUT (
	.p_data(p_data_tb),
	.clk(clk_tb) ,
	.rst(rst_tb) ,
	.data_valid(data_valid_tb) ,
	.par_typ(par_typ_tb) ,
	.par_en(par_en_tb) ,
	.tx_out(tx_out_tb) ,
	.busy(busy_tb)
	);
	
////////////////////////////////////////////////////////////
/////////////////////// parameters ////////////////////////
//////////////////////////////////////////////////////////

	parameter CLK_PERIOD = 5.0 ;
	
//////////////////////////////////////////////////////////
/////////////////////// Clock generator /////////////////
////////////////////////////////////////////////////////

	always #(CLK_PERIOD/2) clk_tb = ~clk_tb ;
	
//////////////////////////////////////////////////////////////
///////////////////////// initial block /////////////////////
////////////////////////////////////////////////////////////

	initial
	begin
		$dumpfile("UART_TX_TOP.vcd");
		$dumpvars ;
		
		//intialization task
		intialize();
		
		//reset task
		reset();
		
		//do task
		read_check_data(8'b0110_1001 , 1'b0 , 1'b0 , 11'b1_01101_001_0 , 1) ; // P_data = 0110_1001 , parity_en = 0 , parity_typ = 0 (even) , expected_output = {fill , stop bit , frame , start bit}
		
		read_check_data(8'b1001_0110 , 1'b1 , 1'b0 , 11'b10_1001_0110_0 , 2) ; // P_data = 1001_0110 , parity_en = 1 , parity_typ = 0 (even) , expected_output = {stop , parity bit , frame , start bit}
		
		read_check_data(8'b1110_1001 , 1'b0 , 1'b0 , 11'b1_1110_1001_0 , 3) ; // P_data = 1110_1001 , parity_en = 0 , parity_typ = 0 (even) , expected_output = {fill , stop bit , frame , start bit}
		
		read_check_data(8'b0001_1110 , 1'b1 , 1'b1 , 11'b11_0001_1110_0 , 4) ; // P_data = 0001_1110 , parity_en = 0 , parity_typ = 1 (odd) , expected_output = {stop bit , parity bit , frame , start bit}
		
		read_check_data(8'b1100_0011 , 1'b1 , 1'b1 , 11'b11_1100_0011_0 , 5) ; // P_data = 1100_0011 , parity_en = 1 , parity_typ = 1 (odd) , expected_output = {stop bit , parity bit , frame , start bit}
		
		read_check_data(8'b1111_1111 , 1'b0 , 1'b1 , 11'b1_1111_1111_0 , 6) ; // P_data = 1111_1111 , parity_en = 0 , parity_typ = 0 (even) , expected_output = {fill , stop bit , frame , start bit}
		
		read_check_data(8'b0111_1011 , 1'b1 , 1'b0 , 11'b10_0111_1011_0 , 7) ; // P_data = 0111_1011 , parity_en = 1 , parity_typ = 0 (even) , expected_output = {stop bit , parity bit , frame , start bit}

		#(CLK_PERIOD*5)	$finish ;
	end
	
//////////////////////////////////////////////////////////
//////////////////////// tasks ///////////////////////////
//////////////////////////////////////////////////////////
	
////////////////// intialization task ///////////////////
	task intialize ;
	begin
		clk_tb        = 1'b0 ;
		p_data_tb     = 8'b0110_1001 ;
		rst_tb        = 1'b0 ;
		data_valid_tb = 1'b0 ;
		par_en_tb     = 1'b0 ;
		par_typ_tb    = 1'b0 ;
	end
	endtask
	
////////////////// reset task //////////////////////////
	task reset ;
	begin
	#CLK_PERIOD rst_tb = 1'b0 ;
	#CLK_PERIOD	rst_tb = 1'b1 ;
	end
	endtask
	
	
////////////read and check the data task /////////////
	task read_check_data ;
	
	input	reg		[7:0]	data  ;
	input	reg				parity_en ;
	input	reg				parity_typ ;
	input	reg		[10:0]	expected ;
	input	integer  k ;

	reg		[8:0]	stored_output ; // i will store the start bit and the frame only
	integer i ;
	begin
		#CLK_PERIOD
		p_data_tb = data  ;
		data_valid_tb = 1'b1 ;
		par_typ_tb  = parity_typ ;
		par_en_tb  = parity_en   ;
		
		#CLK_PERIOD
		data_valid_tb = 1'b0 ;
		
		for(i = 0 ; i < 9 ; i = i+1)
		begin
			#CLK_PERIOD
			stored_output[i] = tx_out_tb ;
		end
		
		//check on the output
		#CLK_PERIOD
		if(par_en_tb)
		begin
			if({1'b1,tx_out_tb,stored_output} == expected)
			begin
				$display("test case %0d passed , par_en = %d , par_typ = %d" , k , parity_en , parity_typ) ;
			end
			
			else
			begin
				$display("test case failed") ;
			end
		end
		
		else
		begin
			if({1'b0,tx_out_tb,stored_output} == expected) //since par_en = 0 therefore no parity bit and tx_out = 1 (stop bit)
			begin
				$display("test case %0d passed , par_en = %d , par_typ = %d" , k , parity_en , parity_typ) ;
			end
			else
			begin
				$display("test case failed") ;
			end
		end
	end
	
	endtask
	
endmodule