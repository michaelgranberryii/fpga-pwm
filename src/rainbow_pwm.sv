module rainbow_pwm 
#(
    parameter R = 8,
    parameter grad_thresh = 1_000_000,
    parameter [31:0] dvsr = 488
)
(
    input logic clk,
    input logic rst,
    output logic pwm_r_out,
    output logic pwm_g_out,
    output logic pwm_b_out
);

// Red LED PWM
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

// Green LED PWM
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

// Blue LED PWM
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