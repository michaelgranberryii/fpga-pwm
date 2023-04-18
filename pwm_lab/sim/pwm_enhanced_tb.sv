`timescale 1ns / 1ps
module pwm_enhanced_tb;
    parameter R_tb = 8;
    logic clk_tb;
    logic rst_tb;
    logic [31:0] dvsr_tb = 4882;
    logic [R_tb:0] duty_tb = 128;
    logic pwm_out_tb;

    parameter duty_cycle = 4;

pwm_enhanced
#(
    .R(R_tb)
)
uut
(
    .clk(clk_tb),
    .rst(rst_tb),
    .dvsr(dvsr_tb),
    .duty(duty_tb),
    .pwm_out(pwm_out_tb)
);

always #duty_cycle clk_tb = ~ clk_tb;

initial begin
    clk_tb = 1;
    rst_tb = 1; #duty_cycle; # duty_cycle;
    rst_tb = 0; #duty_cycle; # duty_cycle;

    #1_000_000_000;
    $stop;
end
    
endmodule