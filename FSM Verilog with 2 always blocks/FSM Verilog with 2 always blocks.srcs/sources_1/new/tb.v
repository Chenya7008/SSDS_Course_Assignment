

`timescale 1ns/1ps

module tb_preamble_simple;


reg clk;
reg rst;
reg start;
wire data_out;


parameter CLK_PERIOD = 10;


preamble uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .data_out(data_out)
);


initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end


initial begin
   
    rst = 1;
    start = 0;
    
   
    #(CLK_PERIOD * 2);
    
    
    rst = 0;
    #(CLK_PERIOD);
    
    
    $display("=== Verilog Preamble FSM Test Started ===");
    $display("Expected pattern: 10101010");
    
    
    $display("Starting preamble generation...");
    start = 1;
    #(CLK_PERIOD);
    start = 0;
    
    
    repeat(8) begin
        #(CLK_PERIOD);
        $display("Time: %0t ns, data_out = %b", $time, data_out);
    end
    
    
    #(CLK_PERIOD * 2);
    
    $display("=== Test Completed ===");
    $display("Check waveform for correct 10101010 pattern");
    
    
    $finish;
end


initial begin
    $dumpfile("preamble_fsm.vcd");
    $dumpvars(0, tb_preamble_simple);
end

endmodule