`timescale 1ns / 1ps
module sin_pwm_tb;
    parameter resolution_tb = 8;
    parameter sin_thresh_tb = 100; // 1_250_000 Hz
    parameter [31:0] dvsr_tb = 5; // sysclk /(pwm_frq*2^8)

    logic clk_tb;
    logic rst_tb;
    logic pwm_sin_out_tb;

    parameter duty_cycle = 4;

    sin_pwm
    #(
        .resolution(resolution_tb),
        .sin_thresh(sin_thresh_tb),
        .dvsr(dvsr_tb)
    )
    uut
    (
        .clk(clk_tb),
        .rst(rst_tb),
        .pwm_sin_out(pwm_sin_out_tb)
    );

    always #duty_cycle clk_tb = ~ clk_tb;

    initial begin
        clk_tb = 1;
        rst_tb = 1; #duty_cycle; # duty_cycle;
        rst_tb = 0; #duty_cycle; # duty_cycle;

        #1_000_000;
        $stop;
    end
endmodule