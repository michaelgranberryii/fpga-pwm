`timescale 1ns / 1ps
module top_pwm_tb;
    parameter resolution_tb = 8;
    parameter grad_thresh_tb = 2000; // 125_000 Hz
    parameter [31:0] dvsr_tb = 48; // sysclk /(pwm_frq*2^8)

    logic clk_tb;
    logic [3:0] sw_tb;
    logic rst_tb;
    logic [2:0] rgb_tb;
    logic servo_out_tb;

    parameter duty_cycle = 4;

    top_pwm
    #(
        .resolution(resolution_tb),
        .grad_thresh(grad_thresh_tb),
        .dvsr(dvsr_tb)
    )
    uut
    (
        .clk(clk_tb),
        .rst(rst_tb),
        .sw(sw_tb),
        .rgb(rgb_tb),
        .servo_out(servo_out_tb)
    );

    always #duty_cycle clk_tb = ~ clk_tb;

    initial begin
        clk_tb = 1;
        rst_tb = 1; #duty_cycle; # duty_cycle;
        rst_tb = 0; #duty_cycle; # duty_cycle;

        sw_tb[0] = 1;
        sw_tb[1] = 0;
        sw_tb[2] = 0;
        sw_tb[3] = 0;
        #5_000_000;

        // rst_tb = 1; #duty_cycle; # duty_cycle;
        // rst_tb = 0; #duty_cycle; # duty_cycle;

        sw_tb[0] = 0;
        sw_tb[1] = 1;
        sw_tb[2] = 0;
        sw_tb[3] = 0;
        #5_000_000;

        // rst_tb = 1; #duty_cycle; # duty_cycle;
        // rst_tb = 0; #duty_cycle; # duty_cycle;

        sw_tb[0] = 0;
        sw_tb[1] = 0;
        sw_tb[2] = 1;
        sw_tb[3] = 0;
        #10_000_000;

        // rst_tb = 1; #duty_cycle; # duty_cycle;
        // rst_tb = 0; #duty_cycle; # duty_cycle;

        sw_tb[0] = 0;
        sw_tb[1] = 0;
        sw_tb[2] = 0;
        sw_tb[3] = 1;
        #10_000_000;
        $stop;
    end
endmodule