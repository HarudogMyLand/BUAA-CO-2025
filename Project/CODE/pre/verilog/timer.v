module timer(
    input clk,
    input reset,
    input on,
    input off,
    input ok,
    input mode,
    input [7:0] value,
    output [7:0] out
);

    parameter SHUTDOWN = 3'b000, WAITING_1 = 3'b001, WAITING_2 = 3'b010, SETTING = 3'b011, sub_state = 3'b101, WORKING = 3'b100;
    reg [2:0] state, next_state;
	reg saved_on;
	reg saved_mode;
	reg [7:0] saved_value;
	reg [7:0] counter;
	
	always @(*) begin
		case(state) 
			SHUTDOWN: begin
				next_state = (on || saved_on) ? WAITING_1 : SHUTDOWN;
			end
			WAITING_1: begin
				next_state = WAITING_2;
			end
			WAITING_2: begin
				next_state = sub_state;
			end
			sub_state: begin
				next_state = (ok) ? SETTING : sub_state;
			end 
			SETTING: begin
				next_state = WORKING;
			end
			WORKING: begin
				next_state = (counter == 0) ? (saved_mode ? WORKING : SHUTDOWN) : WORKING;
			end 
		endcase
	end
	
	always @(posedge clk, posedge reset) begin
		if(reset) begin
			state <= SHUTDOWN;
			counter <= 0;
			saved_on <= 0;
			
			saved_mode <= 0;
			saved_value <= 0;
		end
		else begin
			if(off && (state != SHUTDOWN) && (state != WAITING_1)) begin
				saved_on <= 0;
				state <= SHUTDOWN;
				counter <= 0;
				
				saved_mode <= 0;
				saved_value <= 0;
			end
			else begin
				state <= next_state;
				case(state) 
					SHUTDOWN: begin
						if(on) saved_on <= 1;
						else saved_on <= 0;
				
					end
					sub_state: begin 
						saved_on <= 0;
						if(ok) begin
							
							saved_mode <= mode;
							saved_value <= value;
							counter <= value;
						end
					end
					WORKING: begin
						if(counter > 0) counter <= counter - 1;
						else if(saved_mode == 1) counter <= saved_value;
						else counter <= 0;
					end
					endcase 
			end
		end  
	end
	assign out = (state == SHUTDOWN || state == WAITING_1 || state == WAITING_2) ? 8'hff : ((state == SETTING || state == sub_state) ? 8'd0 : counter);
endmodule