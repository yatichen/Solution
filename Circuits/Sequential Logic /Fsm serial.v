module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 
    parameter   IDLE=3'd0,
    			start=3'd1,
    			receive=3'd2,
    			stop=3'd3,
  				wait_stop=3'd4;
    	
    reg [2:0] state, next_state;
    reg [2:0] cnt;
    // state transition logic
    always @(*) begin
        case (state)
            start:next_state=(in==0)?receive:start;
            receive:begin
                if (cnt==3'b111) begin
                    next_state=stop;
                end else begin
                    next_state=receive;
                end
            end
            stop:next_state=(in==1)?start:wait_stop;
            wait_stop:next_state=(in==1)?start:wait_stop;
            IDLE:next_state=(in==0)?receive:start;
            default:next_state=IDLE;
        endcase
    end
    // state registers
    always @(posedge clk) begin
        if (reset) state <=IDLE;
        else state<=next_state;
    end
    // output logic
    always @(posedge clk) begin
        if (reset) done<=0;
        else if ((state==stop) && (in==1)) done<=1;
        else done<=0;
    end
    
    always @(posedge clk) begin
        if (reset) cnt<=0;
        else if (state==receive) begin
            cnt<=cnt+1;
        end 
        else if ((state==stop) && (in==1)) begin
            cnt<=0;
        end
    end 

endmodule
