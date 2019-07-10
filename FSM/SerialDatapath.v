module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output reg [7:0] out_byte,
    output done
); //

    // Modify FSM and datapath from Fsm_serialdata
    localparam IDLE = 0, DATA0 = 1, DATA1 = 2, DATA2 = 3, DATA3 = 4, DATA4 = 5, DATA5 = 6, STOP_JUDGE = 14;
    localparam DATA6 = 7, DATA7 = 8, DATA8 = 9, PARITY = 10, STOP = 11, WAIT = 12;
    reg [3:0] state;
    reg [3:0] next_state;
    wire flag;

    // New: Add parity checking.
    parity i0(.clk(clk),.in(in),.reset(state == STOP | state == IDLE),.odd(flag));
    
    always @(*)	begin
        case(state)
            IDLE : next_state = in ? IDLE : DATA0;

            DATA0 : begin
			next_state = DATA1;
			out_byte[0] = in;
		    end

            DATA1 : begin
			next_state = DATA2;
			out_byte[1] = in;
		    end

            DATA2 : begin
			next_state = DATA3;
			out_byte[2] = in;
		    end

            DATA3 : begin
			next_state = DATA4;
			out_byte[3] = in;
		    end

            DATA4 : begin
			next_state = DATA5;
			out_byte[4] = in;
		    end

            DATA5 : begin
			next_state = DATA6;
			out_byte[5] = in;
		    end

            DATA6 : begin
			next_state = DATA7;
			out_byte[6] = in;
		    end

            DATA7 : begin
			next_state = PARITY;
			out_byte[7] = in;
		    end
            
	    // Odd Parity Check State
            PARITY : next_state = in ? (flag ? WAIT : STOP_JUDGE) : (flag ? STOP_JUDGE : WAIT);
            
            // STOP bit Check State
            STOP_JUDGE : next_state = in ? STOP : WAIT;
            
            WAIT : next_state = in ? IDLE : WAIT;
            STOP : next_state = in ? IDLE : DATA0;
            default : next_state = IDLE;

        endcase
    end
    
    always @(posedge clk)	begin
        if(reset)	begin
            state <= IDLE;
	end
        else	begin
            state <= next_state;
	end
    end
      
    assign done = (state == STOP);

endmodule


