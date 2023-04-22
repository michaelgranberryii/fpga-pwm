`timescale 1ns / 1ps
module pwm_rgb_tb;
    parameter R_tb = 8;
    parameter grad_thresh_tb = 100; // 1_250_000 Hz
    parameter [31:0] dvsr_tb = 10; // sysclk /(pwm_frq*2^8)

    logic clk_tb;
    logic rst_tb;
    logic rainbow_out_r_tb;
    logic rainbow_out_g_tb;
    logic rainbow_out_b_tb;

    parameter duty_cycle = 4;

// Red
pwm_rgb 
#(
    .R(R_tb),
    .grad_thresh(grad_thresh_tb),
    .dvsr(dvsr_tb)
)
uut_r
(
    .clk(clk_tb),
    .rst(rst_tb),
    .delay(4),
    .rainbow_out(rainbow_out_r_tb)
);

// Green
pwm_rgb 
#(
    .R(R_tb),
    .grad_thresh(grad_thresh_tb),
    .dvsr(dvsr_tb)
)
uut_g
(
    .clk(clk_tb),
    .rst(rst_tb),
    .delay(0),
    .rainbow_out(rainbow_out_g_tb)
);

// Blue
pwm_rgb 
#(
    .R(R_tb),
    .grad_thresh(grad_thresh_tb),
    .dvsr(dvsr_tb)
)
uut_b
(
    .clk(clk_tb),
    .rst(rst_tb),
    .delay(2),
    .rainbow_out(rainbow_out_b_tb)
);

always #duty_cycle clk_tb = ~ clk_tb;

initial begin
    clk_tb = 1;
    rst_tb = 1; #duty_cycle; # duty_cycle;
    rst_tb = 0; #duty_cycle; # duty_cycle;

    #6_000_000;
    $stop;
end
    

endmodule