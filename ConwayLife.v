module top_module(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q ); 
    
    parameter SIZE = 16;
    integer i = 4'b0;
    integer j = 4'b0;
    reg [3:0] count = 4'b0;
    reg [255:0] temp = 256'b0;
    reg [255:0] p = 256'b0;
    reg [3:0] row[0:2];
    reg [3:0] column[0:2];
    reg [7:0] coor[0:7];
    

    always @(posedge clk)   begin
	if(load)	
		temp = data;
	else 	begin
        for (i = 0; i < 16; i = i + 1) begin
		// ROW Number
                row[0] = (i + 1'b1) % SIZE;
                row[1] = i % SIZE;
                row[2] = (i - 1'b1) % SIZE;
		//$display("row[1] = %b", row[1]);

                for (j = 0; j < 16; j = j + 1)  begin
		      // Column Number
                    column[0] = (j + 1'b1) % SIZE;
                    column[1] = j % SIZE;
                    column[2] = (j - 1'b1) % SIZE;
		      // Neighbor Coordinates
                    coor[0] = row[1]*16 + column[2]; 
                    coor[1] = row[1]*16 + column[0];
                    coor[2] = row[2]*16 + column[1];
                    coor[3] = row[2]*16 + column[2];
                    coor[4] = row[2]*16 + column[0];
                    coor[5] = row[0]*16 + column[1];
                    coor[6] = row[0]*16 + column[2];
                    coor[7] = row[0]*16 + column[0];
		    $display("%b", coor[0]);
		       // Calculate ALIVE neighbors
		    count = 4'b0;
                    count = temp[coor[0]] + temp[coor[1]] + temp[coor[2]] + temp[coor[3]] + temp[coor[4]] + temp[coor[5]] + temp[coor[6]] + temp[coor[7]];
		       // State Transition
                    case (count)
                        4'd0: p[i*16+j] = 1'b0;
                        4'd1: p[i*16+j] = 1'b0;
                        4'd2: p[i*16+j] = temp[i*16+j];
                        4'd3: p[i*16+j] = 1'b1;
                        default : p[i*16+j] = 1'b0;
                    endcase
                    
                end
            end
		temp = p;
	end
    end
    
    assign q = temp;
                  

            

endmodule
