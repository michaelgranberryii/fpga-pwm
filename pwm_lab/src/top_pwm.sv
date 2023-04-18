module top_pwm
#(
    parameter resolution = 8,
    parameter grad_thresh = 2_500_000,
    parameter [31:0] dvsr = 4882 // sysclk /(pwm_frq*2^8)
)
(
    input logic clk,
    input logic [3:0] sw,
    input logic rst,
    output logic [2:0] rgb
);

logic linear_out;
logic sin_out;
logic r_out;
logic g_out;
logic b_out;

linear_pwm lin_pwm_i 
(
    .clk(clk),
    .rst(rst),
    .pwm_linear_out(linear_out)
);


sin_pwm sin_pwm_i 
(
    .clk(clk),
    .rst(rst),
    .pwm_sin_out(sin_out)
);

rainbow_pwm rainbow_pwm_i
(
    .clk(clk),
    .rst(rst),
    .pwm_r_out(r_out),
    .pwm_g_out(g_out),
    .pwm_b_out(b_out)
);


always_latch begin
    if (sw[0]) begin
        rgb[0] <= linear_out;
        rgb[1] <= 0;
        rgb[2] <= 0;
    end
    else if (sw[1]) begin
        rgb[0] <= 0;
        rgb[1] <= 0;
        rgb[2] <= sin_out;
    end
    else if (sw[2]) begin
        rgb[0] <= r_out;
        rgb[1] <= g_out;
        rgb[2] <= b_out;
    end
    else if (sw[3]) begin
        rgb[0] <= 0;
        rgb[1] <= 0;
        rgb[2] <= 1;
    end
    else begin
        rgb[0] <= 0;
        rgb[1] <= 0;
        rgb[2] <= 0;
    end
end 
endmodule