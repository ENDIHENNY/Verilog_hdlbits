module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 
    
    wire [2:1] enain;
    reg pm_count;
    
    defparam
    	iss.i0.RESETVALUE = 4'h0,
    	iss.i0.ZEROVALUE = 4'h0,
    	iss.i1.RESETVALUE = 4'h0,
    	iss.i1.ZEROVALUE = 4'h0,
    
        imin.i0.RESETVALUE = 4'h0,
    	imin.i0.ZEROVALUE = 4'h0,
    	imin.i1.RESETVALUE = 4'h0,
    	imin.i1.ZEROVALUE = 4'h0,
    	imin.i1.UPBOUND = 4'b0101,
    
        ihour.i0.RESETVALUE = 4'h2,
    	ihour.i0.ZEROVALUE = 4'h1,
    	ihour.i1.RESETVALUE = 4'h0,
    	ihour.i1.ZEROVALUE = 4'h0,
    	ihour.i1.UPBOUND = 4'b0001;
    
    
    count_ss iss(.clk(clk),.reset(reset),.ena(ena),.ss(ss));
    count_min imin(.clk(clk),.reset(reset),.ena(enain[1]),.min(mm));
    count_hour ihour(.clk(clk),.reset(reset),.ena(enain[2]),.hour(hh));
    
    assign enain = {(mm === 8'h59) & (ss === 8'h59), (ss === 8'h59)};
    
    always @(posedge clk)	begin   
        if(reset)	begin
            pm <= 1'b0;
        end
            else 	begin
                if(enain[2] & (hh === 8'h11))	
                    pm <= ~pm;
                else	
                    pm <= pm;
            end     
    end
    
        	

endmodule

module count_ss(
    input clk,
    input reset,
    input ena,
    output [7:0] ss
);

    
    count10 i0(.clk(clk),.reset(reset | (ss === 8'h59)),.ena(ena),.q(ss[3:0]));
    count10 i1(.clk(clk),.reset(reset | (ss === 8'h59)),.ena(ena & ss[3] & ss[0]),.q(ss[7:4]));
         
endmodule

module count_min( 
    input clk,
    input reset,
    input ena,
    output [7:0] min
);
    
    count10 i0(.clk(clk),.reset(reset),.ena(ena),.q(min[3:0]));
    count10 i1(.clk(clk),.reset(reset),.ena(min[3] & min[0] & ena),.q(min[7:4]));
    
endmodule

module count_hour( 
    input clk,
    input reset,
    input ena,
    output [7:0] hour
);

    countset i0(.clk(clk),.reset(reset),.set(ena & ((hour[4] & hour[1] & ~hour[0]) | hour[3] & hour[0] )),.d((hour[3] & hour[0]) ? 4'b0000 : 4'b0001),.ena(ena),.q(hour[3:0]));
    countset i1(.clk(clk),.reset(ena & (hour[4] & hour[1] & ~hour[0])),.set(reset),.d(4'b0001),.ena(hour[3] & hour[0] & ena),.q(hour[7:4]));
    
endmodule

        
module count10(
    input clk,
    input reset,
    input ena,
    output [3:0] q
);
    parameter RESETVALUE = 4'h0;
    parameter ZEROVALUE = 4'h0;
    parameter UPBOUND = 4'b1001;
    
    
    always @(posedge clk)	begin
        if(reset)
            q <= RESETVALUE;
 
        else	begin
            if(ena)	begin
                if(q === UPBOUND)
                    q <= ZEROVALUE;
                else
                    q <= q + 1'b1;
            end
            	else 
                    q <= q;
        end
    end
     
endmodule  


module countset(
    input clk,
    input reset,
    input ena,
    input set,
    input [3:0] d,
    output [3:0] q
);
    parameter RESETVALUE = 4'h0;
    parameter ZEROVALUE = 4'h0;
    parameter UPBOUND = 4'b1001;
    
    
    always @(posedge clk)	begin
        if(reset)
            q <= RESETVALUE;
 
        else	begin
            if(set)
                q <= d;
            else	begin
                if(ena)		begin
                	if(q === UPBOUND)
                    	q <= ZEROVALUE;
                	else
                    	q <= q + 1'b1;
                end
                else
                    q <= q;
            end
        end
    end
     
endmodule  
        

