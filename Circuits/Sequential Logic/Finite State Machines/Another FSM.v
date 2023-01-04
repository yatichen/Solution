module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input x,
    input y,
    output f,
    output g
); 
    parameter A=4'd0, 
    		F1=4'd1, // set f=1 when de-assert resetn
    		B1=4'd2, // start monitoring x
    		B2=4'd3, // monitor x second sequence "0" when first is "1"
    		B3=4'd4, // monitor x third sequence "1" when previous is "10"
    		C1=4'd5, // start monitot y 
    		C2=4'd6, // monitor y second cycle "1" when first is "1"
    		G0=4'd7, // set g=0 shen monitor y != 11
    		G1=4'd8; // set g=1 when monitor y==11
    reg [3:0] state, next;  
    
    // state translation 
    always @(*) begin
        case (state) 
            A:next=F1;
            F1:next=B1;
            B1:next=x?B2:B1;
            B2:next=x?B2:B3;
            B3:next=x?C1:B1;
            C1:next=y?G1:C2;
            C2:next=y?G1:G0;
            G0:next=G0;
            G1:next=G1;
            default: next=A;
        endcase
    end
    
    // register state 
    always @(posedge clk) begin
        if (~resetn) begin
            state<=A;
        end
        else begin 
            state<=next;
        end
    end
    // output logic 	
    assign f = (state==F1);
    assign g = (state==G1) | (state==C1) | (state==C2) ;

    

endmodule
