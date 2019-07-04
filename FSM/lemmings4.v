module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 
    
    reg [2:0] state;
    reg [2:0] next_state;
    reg [7:0] cnt = 8'b0;
    
    parameter LW = 3'b000, RW = 3'b001, RF = 3'b010, LF = 3'b011, LDIG = 3'b100, RDIG = 3'b101, DEAD = 3'b110;// LW - left walk; 
    // RW - right walk; LF - left fall; RF - right fall
    
    always @(*) begin
        // State transition logic
        case (state)
            LW : next_state = ground ? (dig ? LDIG : (bump_left ? RW : LW)) : LF;
            RW : next_state = ground ? (dig ? RDIG : (bump_right ? LW : RW)) : RF;
            LF : next_state = (cnt >= 5'd20 & ground == 1'b1) ? DEAD : (ground ?  LW : LF);
            RF : next_state = (cnt >= 5'd20 & ground == 1'b1) ? DEAD : (ground ?  RW : RF);
            LDIG : next_state = ground ? LDIG : LF;
            RDIG : next_state = ground ? RDIG : RF;
            DEAD : next_state = DEAD;
            default : next_state = LW;
        endcase
    end
    
    always @(posedge clk or posedge areset)	begin
        if(areset)	
            state <= LW;
        else	
            state <= next_state;
        end
            
    
    assign walk_left = (state == DEAD) ? 1'b0 : (state == LW) ? 1'b1 : 1'b0;
    assign walk_right = (state == DEAD) ? 1'b0 : (state == RW) ? 1'b1 : 1'b0;
    assign aaah = (state == DEAD) ? 1'b0 : (state == RF | state == LF) ? 1'b1 : 1'b0;
    assign digging = (state == DEAD) ? 1'b0 : (state == LDIG | state == RDIG) ? 1'b1 : 1'b0; 
    
    always @(posedge clk)	begin
        if(state == LF | state == RF)
            cnt = cnt + 1'b1;
        else
            cnt = 8'b0;
    end

endmodule
