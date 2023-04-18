module rainbow_pwm (
    input logic clk,
    input logic rst,
    output logic pwm_r_out,
    output logic pwm_g_out,
    output logic pwm_b_out
);

parameter R = 8;
parameter grad_thresh = 100_000;
parameter [31:0] dvsr = 488;

pwm_rgb
#(
    .R(R),
    .grad_thresh(grad_thresh),
    .dvsr(dvsr)
)
red
(
    .clk(clk),
    .rst(rst),
    .delay(4),
    .rainbow_out(pwm_r_out)
);

pwm_rgb
#(
    .R(R),
    .grad_thresh(grad_thresh),
    .dvsr(dvsr)
)
green
(
    .clk(clk),
    .rst(rst),
    .delay(0),
    .rainbow_out(pwm_g_out)
);

pwm_rgb
#(
    .R(R),
    .grad_thresh(grad_thresh),
    .dvsr(dvsr)
)
blue
(
    .clk(clk),
    .rst(rst),
    .delay(2),
    .rainbow_out(pwm_b_out)
);

endmodule