`timescale 1ns / 1ps
module linear_pwm_tb;
    logic clk_tb;
    logic rst_tb;
    logic pwm_out_tb;

    parameter resolution_tb = 8;
    parameter grad_thresh_tb = 250_000; // sysclk / 500
    parameter [31:0] dvsr_tb = 488; // sysclk /(pwm_frq*2^8) = 1000 kHz

    parameter duty_cycle = 4;

    linear_pwm 
    #(
        .resolution(resolution_tb),
        .grad_thresh(grad_thresh_tb),
        .dvsr(dvsr_tb)
    )
    uut(
        .clk(clk_tb),
        .rst(rst_tb),
        .pwm_out(pwm_out_tb)
    );

    always #duty_cycle clk_tb = ~ clk_tb;

initial begin
    clk_tb = 1;
    rst_tb = 1; #duty_cycle; # duty_cycle;
    rst_tb = 0; #duty_cycle; # duty_cycle;

    #500_000_000;
    $stop;
end
    
endmodule