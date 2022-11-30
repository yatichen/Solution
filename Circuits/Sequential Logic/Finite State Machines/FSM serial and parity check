module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //
parameter IDLE=3'd0,START=3'd1,RECEIVE=3'd2,CHECK=3'd3,STOP=3'd4,WAIT=3'd5;
    reg [2:0] state, next;
    reg [2:0] cnt;
    reg [7:0] fifo;
    reg odd_reset;
    wire odd_reg;
    // Modify FSM and datapath from Fsm_serialdat
    
    // state transition logic
    always @ (*) begin
        case (state) 
            IDLE:next=(in==0)?RECEIVE:START;
            START:next=(in==0)?RECEIVE:START;
            RECEIVE:next=(cnt==3'd7)?CHECK:RECEIVE;
            CHECK:next=(odd_reg^in)?STOP:WAIT; // key code to decide whether satisify parity rule 
            STOP:next=(in==1)?START:WAIT;
            WAIT:next=(in==1)?START:WAIT;
        endcase
    end
    // state registers
    always @(posedge clk) begin
        if (reset) state<=IDLE;
        else state<=next;
    end
        // cnt logic
    always @(posedge clk) begin
        if (reset) cnt<=0;
        else if (state==RECEIVE) cnt<=cnt+1;
        else cnt<=0;
    end
    //  buffers
    always @(posedge clk) begin
        if (reset) fifo<=8'b0;
        else if (next==RECEIVE) fifo[cnt]<=in;
    end
    

    
    
    // New: Add parity checking.
    parity u_parity (
        .clk(clk),
        .reset(reset|odd_reset),
        .in(in),
        .odd(odd_reg));
    
    always @(posedge clk) begin
        if (reset) odd_reset<=1;
        else if ((next==RECEIVE) || (next==CHECK)) odd_reset<=0;
        else odd_reset<=1;
                 
    end
    
    
    // done & out_byte logic
    always @(posedge clk) begin
        if (reset) done<=1'b0;
        else if ((odd_reg==1) && (state==STOP) && (in==1)) begin
            done<=1;
        end else done<=0;
    end
    assign out_byte=(done==1)?fifo:8'b0;

endmodule
