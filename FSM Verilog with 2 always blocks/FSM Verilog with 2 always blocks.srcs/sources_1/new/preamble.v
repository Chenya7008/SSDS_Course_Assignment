module preamble (
    input clk,
    input rst,
    input start,
    output reg data_out
);


parameter IDLE = 4'b0000;  
parameter S0   = 4'b0001;  
parameter S1   = 4'b0010;  
parameter S2   = 4'b0011;  
parameter S3   = 4'b0100; 
parameter S4   = 4'b0101;  
parameter S5   = 4'b0110;  
parameter S6   = 4'b0111;  
parameter S7   = 4'b1000; 

reg [3:0] curr_state, next_state;


always @(curr_state, start) begin
    
    next_state = curr_state;
    data_out = 1'b0;
    
    case (curr_state)
        IDLE: begin
            data_out = 1'b0;
            if (start == 1'b1)
                next_state = S0;
            else
                next_state = IDLE;
        end
        
        S0: begin
            data_out = 1'b1;  
            next_state = S1;
        end
        
        S1: begin
            data_out = 1'b0;  
            next_state = S2;
        end
        
        S2: begin
            data_out = 1'b1;  
            next_state = S3;
        end
        
        S3: begin
            data_out = 1'b0; 
            next_state = S4;
        end
        
        S4: begin
            data_out = 1'b1;  
            next_state = S5;
        end
        
        S5: begin
            data_out = 1'b0;  
            next_state = S6;
        end
        
        S6: begin
            data_out = 1'b1;  
            next_state = S7;
        end
        
        S7: begin
            data_out = 1'b0;  
            next_state = IDLE; 
        end
        
    endcase
end


always @(posedge clk) begin
    if (rst == 1'b1)
        curr_state <= IDLE; 
    else
        curr_state <= next_state;
end

endmodule