package state_machine_definitions;

	enum logic [1:0] {__RESET = 2'b00, __IDLE = 2'b01, __PROC = 2'b10, __DONE = 2'b11} state;
	// ...  

endpackage 
`define circularleftshift(x, n) ((x << n) | (x >> (32-n)))


module sha1_core(
	input logic clk,
	input logic reset_n,
	input logic start,

	input logic [511:0] message,

	output logic [159:0] q_data,
	input logic [31:0] hash_value_i[4:0],
	input logic [31:0] K[3:0],

	// for illustration purposes only ... 	
	output logic q_start,
	output logic q_done


);

	import state_machine_definitions::*;
	
	
	localparam LOOP_ITERATIONS = 80;
	localparam ITERATIONS      = LOOP_ITERATIONS - 1; // 79 iterations (80 - 1)
	localparam BITWIDTH        = $clog2(ITERATIONS);  // 7 bits (since log2(79) ≈ 6.3, clogs up to 7)
	

    logic [31:0] W [79:0]; // Array of 80 elements, each 32 bits wide (word_array[79:0])

    logic [6:0] t;         // 7-bit wide word_counter (for tracking iterations 0-79)
    logic [31:0] A, B, C, D, E;
	
	
	

	/* ### start pulse detection ##############################################
	
	CPU asserts a start pulse ...
	
										  ___________________________________________________
	start_signal:		__________|                                                   |_______________________________________
	
										 ^
										 |
										 
								 ACTUAL START
						
	
	We are using the start_signal to derive a 50MHz related start pulse ..., which is only high for 20ns ... 
	
							             _
							____________| |________________________________________________________________________________________
	
	
	We use this start pulse to trigger our sha-1 processing stage ...
	
	*/
	
	// with the following structure, we are detecting the rising edge of our start signal ... 
	
	logic [3:0] sync_reg = 0;
	
	// shifting data (start signal) from the right-hand side. shifting everything to the left ... newest data is placed at the LSB side ...
	always_ff@(posedge clk)
		begin : start_detection
			if(reset_n == 1'b0)
				sync_reg <= 4'b0000;
			else
				sync_reg <= {sync_reg[2:0],start};
		
		end : start_detection

	// comparator that continuously evaluates the content of our sync_reg ...
	logic sync_start; assign sync_start = (sync_reg == 4'b0011) ? 1'b1 : 1'b0; 	   // Otherwise, set sync_start to 0

	
	// ### 'state-machine' ... #######################################################################################################

	logic [BITWIDTH-1:0] state_counter = 'd0;
	
	always_ff@(posedge clk)
		begin : state_machine
			if(reset_n == 1'b0)
				begin
					state_counter <= 0;
					t <= 'd0;
					state 		  <= __RESET;
				end
			else
				begin
					case(state)
						__RESET:	
							begin
							state_counter <= 0;
							t <= 'd0;
							state 		  <= __IDLE;
							end	
						__IDLE: 
							begin
								state_counter <= 0;
								t <= 'd16;
								
								A <= hash_value_i[0];
								B <= hash_value_i[1];
								C <= hash_value_i[2];
								D <= hash_value_i[3];
								E <= hash_value_i[4];
								
								W[0] 	<= message[31:0];
								W[1] 	<= message[63:32];
								W[2] 	<= message[95:64];
								W[3] 	<= message[127:96];
								W[4] 	<= message[159:128];
								W[5] 	<= message[191:160];
								W[6] 	<= message[223:192];
								W[7] 	<= message[255:224];
								W[8] 	<= message[287:256];
								W[9] 	<= message[319:288];
								W[10] <= message[351:320];
								W[11] <= message[383:352];
								W[12] <= message[415:384];
								W[13] <= message[447:416];
								W[14] <= message[479:448];
								W[15] <= message[511:480];
								
								if(t < 80)
								begin									
									W[t] <= `circularleftshift((W[t-3] ^ W[t-8] ^ W[t-14] ^ W[t-16]),1);
									t <= t + 1;
								end
								if(sync_start)
									state <= __PROC;
								end
						__PROC: 
							begin
							if(state_counter >= 0 && state_counter <= 19)
								begin		
									A <= `circularleftshift(A,5) + ((B & C) | ( (~B) & D)) + E + K[0] + W[state_counter];

								end
								else if(state_counter >= 20 && state_counter <= 39)
								begin
									A <= `circularleftshift(A,5) + (B ^ C ^ D) + E + K[1] + W[state_counter];
									
								end
								else if(state_counter >= 40 && state_counter <= 59)
								begin
									A <= `circularleftshift(A,5) + ((B & C) | (B & D) | (C & D)) + E + K[2] + W[state_counter];
									
								end
								else if(state_counter >= 60 && state_counter <= 79)
								begin
									A <= `circularleftshift(A,5) + (B ^ C ^ D) + E + K[3] + W[state_counter];
									
								end
								
								B <= A;
								C <=`circularleftshift(B,30);
								D <= C;
								E <= D;
								
								$display("A == %x\n",A);
								$display("B == %x\n",B);
								$display("C == %x\n",C);
								$display("D == %x\n",D);
								$display("E == %x\n",E);
								
								if(state_counter == ITERATIONS)
									begin
										state_counter <= 0;
										state         <= __DONE;
									end
								else
									begin
										state_counter <= state_counter + 1;
										state         <= __PROC;
									end
							end
						__DONE:
							begin
								state_counter <= 0;
								
								q_data = {hash_value_i[0]+A, hash_value_i[1]+B, hash_value_i[2]+C, hash_value_i[3]+D, hash_value_i[4]+E};
								$display("q_data == %x\n",q_data);
								
								state			  <= __IDLE;
							end
						default:
							begin
								
								state_counter <= 0;
								state 		  <= __RESET;
							end
					endcase
				end
			end : state_machine
				
				
	assign q_done = (state == __DONE) ? 1'b1 : 1'b0;
				
			

endmodule