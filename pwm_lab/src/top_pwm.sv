module top_pwm
    #(
    parameter resolution = 8,
    parameter grad_thresh = 2_500_000,
    parameter [31:0] dvsr = 4882 // sysclk /(pwm_frq*2^8)
    )
    (
    input logic clk,
    input logic rst,
    input logic [3:0] sw,
    output logic [2:0] rgb,
    output logic servo_out
    );

    logic linear_out;
    logic sin_out;
    logic servo_out_reg;
    logic r_out;
    logic g_out;
    logic b_out;

    // Part 1 -- Linear LED
    linear_pwm 
    #(
        .resolution(resolution),
        .grad_thresh(grad_thresh),
        .dvsr(dvsr)
    )
    lin_pwm_i 
    (
        .clk(clk),
        .rst(rst),
        .pwm_linear_out(linear_out)
    );

    // Part 2 -- Sine LED
    sin_pwm 
    #(
        .resolution(resolution),
        .sin_thresh(grad_thresh),
        .dvsr(dvsr)
    )
    sin_pwm_i
    (
        .clk(clk),
        .rst(rst),
        .pwm_sin_out(sin_out)
    );

    // Part 3 -- Servo
    sin_pwm 
    #(
        .resolution(resolution),
        .sin_thresh(grad_thresh),
        .dvsr(dvsr)
    )
    servo_sin_pwm_i
    (
        .clk(clk),
        .rst(rst),
        .pwm_sin_out(servo_out_reg)
    );


    // Part 4 -- Rainbow LED
    rainbow_pwm 
    #(
        .R(resolution),
        .grad_thresh(grad_thresh),
        .dvsr(dvsr)
    )
    rainbow_pwm_i
    (
        .clk(clk),
        .rst(rst),
        .pwm_r_out(r_out),
        .pwm_g_out(g_out),
        .pwm_b_out(b_out)
    );


    // Output control
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            servo_out <= 0;
        end
        else begin
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
                servo_out <= servo_out_reg;
                rgb[0] <= 0;
                rgb[1] <= 0;
                rgb[2] <= 0;
            end
            else begin
                rgb[0] <= 0;
                rgb[1] <= 0;
                rgb[2] <= 0;
            end
        end
    end 
endmodule