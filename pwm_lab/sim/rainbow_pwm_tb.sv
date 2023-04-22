`timescale 1ns / 1ps
module rainbow_pwm_tb;
    logic clk_tb;
    logic rst_tb;
    logic pwm_r_out_tb;
    logic pwm_g_out_tb;
    logic pwm_b_out_tb;

    parameter duty_cycle = 4;


rainbow_pwm 
#(
    .R(8),
    .grad_thresh(1_000), // 125_000 Hz
    .dvsr(100) // sysclk /(pwm_frq*2^8), f_pwm = 4882 Hz
)
uut
(
    .clk(clk_tb),
    .rst(rst_tb),
    .pwm_r_out(pwm_r_out_tb),
    .pwm_g_out(pwm_g_out_tb),
    .pwm_b_out(pwm_b_out_tb)
);


always #duty_cycle clk_tb = ~ clk_tb;

initial begin
    clk_tb = 1;
    rst_tb = 1; #duty_cycle; # duty_cycle;
    rst_tb = 0; #duty_cycle; # duty_cycle;

    #20_000_000;
    $stop;
end

endmodule