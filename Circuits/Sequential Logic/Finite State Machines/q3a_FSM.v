module top_module (
    input clk,
    input reset,   // Synchronous reset
    input s,
    input w,
    output z
);
   parameter A=1'b0, B=1'b1;
    reg state, next;
    reg [1:0] cnt;
    reg [2:0] buffer;
 // state transition logic
    always @(*) begin
        case (state)
            A:next=s?B:A;
            B:next=B;
        endcase
    end
 
 // state registers 
    always @(posedge clk) begin
        if (reset) state<=A;
        else state<=next;
    end
    
    
 // buffer to receive sequential data 
    always @ (posedge clk) begin
        if (reset) buffer<=3'b0;
        else if (state==B) begin
            buffer[2:0]<={buffer[1:0],w};
        end
    end
    
 // counters
    always @(posedge clk) begin
        if (reset) cnt<=2'b0;
        else if (cnt==2'd3) begin
            cnt<=1;
        end
        else if (next==B) begin
            cnt<=cnt+1;
        end
    end
    
 //output 
    assign z = (cnt==1) & ((buffer==3'b011) | (buffer==3'b101) | (buffer==3'b110) );

endmodule
