module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack );
    
    reg shift_ena;
    reg done_counting;
    reg q_counter;
    reg [3:0] delay;
    reg [9:0] cycle;
    reg count_done;

    fsm_control i0(.clk(clk),.reset(reset),.data(data),.shift_ena(shift_ena),.counting(counting),.done_counting((count == 4'b0) & count_done),.done(done),.ack(ack));
    data_shift i1(.clk(clk),.shift_ena(shift_ena),.count_ena(count_done),.data(data),.q(count));
    counter i2(.clk(clk),.reset(~counting),.q(cycle),.count_done(count_done));


endmodule

module fsm_control(
    input clk,
    input reset,      // Synchronous reset
    input data,
    output shift_ena,
    output counting,
    input done_counting,
    output done,
    input ack );
    
    localparam IDLE = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5;
    localparam S6 = 6, S7 = 7, S8 = 8, S9 = 9, WAIT = 10;
    
    reg [3:0] state;
    reg [3:0] next_state;
    
    always @(*)	begin     
		shift_ena = 1'b0;
		counting = 1'b0;
		done = 1'b0;       
        case(state)	
            IDLE : begin
                next_state = data ? S1 : IDLE;
            end
            
            S1 : begin
                next_state = data ? S2 : IDLE;
            end
            
            S2 : begin
                next_state = data ? S2 : S3;
            end
            
            S3 : begin
                next_state = data ? S4 : IDLE;
            end
            
            S4 : begin
                next_state = S5;
                shift_ena = 1'b1;
            end
            
            S5 : begin
                next_state = S6;
                shift_ena = 1'b1;
            end
            
            S6 : begin
                next_state = S7;
                shift_ena = 1'b1;
            end
            
            S7 : begin
                next_state = S8;
                shift_ena = 1'b1;
            end
            
            S8 : begin
                next_state = done_counting ? S9 : S8;
                counting = 1'b1;
            end
            
            S9 : begin
                next_state = ack ? IDLE : S9;
                done = 1'b1;
            end
            
            default : begin
                next_state = IDLE;
            end
        endcase
    end
    
    always @(posedge clk)	begin
        if(reset)
            state <= IDLE;
        else
            state <= next_state;
    end
               

endmodule


module counter(
    input clk,
    input reset,
    output [9:0] q,
    output count_done);
    
    always @(posedge clk)   begin
        if(reset)   begin
            q <= 10'd0;
            end
        else begin
            q <= (q == 10'd999) ? 10'd0 : q + 10'd1;
            end
    end
    assign count_done = (q === 10'd999);

endmodule



module data_shift(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q);
    
    always @(posedge clk)   begin
        if(shift_ena)   begin
            q <= {q,data};
        end
        if(count_ena)   begin
            q <= q - 4'd1;
        end
    end    

endmodule

