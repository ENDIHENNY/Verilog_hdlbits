module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input x,
    input y,
    output f,
    output g
); 
    localparam A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, G = 6, DONE = 7, C2 = 8;
    
    reg [3:0] state;
    reg [3:0] next_state;
    
    always @(*)	begin
        case(state)	
            A : begin
                next_state = B;
                f = 0;
                g = 0;
            end
            
            B : begin
                next_state = C;
                f = 1;
                g = 0;
            end
            
            C : begin
                next_state = x ? C2 : C;
                f = 0;
                g = 0;
            end
            
            C2 : begin
                next_state = x ? C2 : D;
                f = 0;
                g = 0;
            end
            
            D : begin
                next_state = x ? E : C;
                f = 0;
                g = 0;
            end
            
            E : begin
                next_state = y ? G : F;
                f = 0;
                g = 1;
            end
            
            F : begin
                next_state = y ? G : DONE;
                f = 0;
                g = 1;
            end
            
            G : begin
                next_state = G;
                f = 0;
                g = 1;
            end
            
            DONE : begin
                next_state = DONE;
                f = 0;
                g = 0;
            end
            
            default : begin
                next_state = A;
                f = 0;
                g = 0;
            end
        endcase
    end
    
    always @(posedge clk)	begin
        if(~resetn)
            state <= A;
        else
            state <= next_state;
    end
    
            

endmodule
