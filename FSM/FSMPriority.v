module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input [3:1] r,   // request
    output [3:1] g   // grant
); 
    
    localparam A = 0, B = 1, C = 2, D = 3;
    reg [2:0] state;
    reg [2:0] next_state;
    
    always @(*)	begin
        case(state)	
            A : begin
                if(r[1])	
                    next_state = B;
                else begin
                    if(r[2])
                    next_state = C;
                    else begin
                        if(r[3])
                            next_state = D;
                        else
                            next_state = A;
                    end
                end
                g = 3'b000;
            end
            
            B : begin
                next_state = r[1] ? B : A;
                g = 3'b001;
            end
            
            C : begin
                next_state = r[2] ? C : A;
                g = 3'b010;
            end
            
            D : begin
                next_state = r[3] ? D : A;
                g = 3'b100;
            end
            
            default : begin
                next_state = A;
                g = 3'b000;
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
