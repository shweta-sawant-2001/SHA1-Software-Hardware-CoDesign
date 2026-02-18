`timescale 1ns/1ps
`define HALF_CLOCK_PERIOD   10
`define RESET_PERIOD 	   100
`define DELAY 	    	   	200
`define SIM_DURATION 	  5000

module sha1_tb();

	// ### signals that should get monitored ... 
	logic tb_local_clock = 0;
	
	logic tb_local_reset_n = 0;

	logic tb_start;
	
	logic tb_done;
	
	//input string "abc"
	//logic [511:0] tb_data = 512'h00000018000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000061626380;
	
	//Input String "FSOC22/23 is fun!"
	//logic [511:0] tb_data = 512'h4653434f32342f32352069732066756e218000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088;
	  logic [511:0] tb_data = 512'h0000008800000000000000000000000000000000000000000000000000000000000000000000000000000000218000002066756e3520697332342f3246534f43;

	
	logic [159:0] tb_q;
	
	logic [31:0] tb_Hash [4:0] = '{32'hC3D2E1F0, 32'h10325476, 32'h98BADCFE, 32'hEFCDAB89, 32'h67452301};
	
	logic [31:0] tb_K [3:0] 	= '{32'hCA62C1D6, 32'h8F1BBCDC, 32'h6ED9EBA1, 32'h5A827999};
	
	// ### clock generation process ...

 	initial 
		begin: clock_generation_process
				forever begin
					#`HALF_CLOCK_PERIOD tb_local_clock = ~tb_local_clock;
				end
		end	
	
	initial 
		begin: reset_generation_process
			$display ("Simulation starts ...");
			// reset assertion ... 
			#`RESET_PERIOD tb_local_reset_n = 1'b1;
		end
		
	logic [7:0] counter = 0;
	
	always_ff@(posedge tb_local_clock)
		counter = counter + 1;
		
	// if counter is equal to 255, tb_start is set to one ... 
	assign tb_start = (counter >  128) ? 1'b1 : 1'b0;
	
	initial
	begin
		#`SIM_DURATION
		$display ("Simulation done ...");
		$stop();
	end
	
	sha1_state_machine dut_0 (.clk(tb_local_clock),
									  .reset_n(tb_local_reset_n),
									  .message(tb_data),
									  .start(tb_start),
									  .q_done(tb_done),
									  .q_data(tb_q),
									  .hash_value_i(tb_Hash),
									  .K(tb_K)
									 );
									 

endmodule