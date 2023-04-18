`timescale 1ns / 1ps
module linear_pwm 
#(
    parameter resolution = 8,
    parameter grad_thresh = 2_500_000,
    parameter [31:0] dvsr = 4882 // sysclk /(pwm_frq*2^8)
)
(
    input logic clk,
    input logic rst,
    output logic pwm_linear_out
);


logic [resolution:0] duty;
logic [22:0] counter;
logic gradient_pulse;
logic [resolution:0] duty_reg;

pwm_enhanced
#(
    .R(resolution)
)
pwm_enhanced_i
(
    .clk(clk),
    .rst(rst),
    .dvsr(dvsr),
    .duty(duty),
    .pwm_out(pwm_linear_out)
);


always_ff @(posedge clk) begin
    if (rst) begin
        duty_reg <= 0;
        counter <= 0;
    end
    else begin
        if (counter < grad_thresh) begin
            counter <= counter + 1;
            gradient_pulse <= 0;
        end
        else begin
            counter <= 0;
            gradient_pulse <= 1;
        end

        if (gradient_pulse == 1) begin
            duty_reg <= duty_reg + 1;
        end

        if (duty_reg == 256) begin
            duty_reg <= 0;
        end
    end
end

assign duty = duty_reg;
    
endmodule