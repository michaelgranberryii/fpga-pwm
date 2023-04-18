module pwm_rgb 
# (
    parameter R = 8,
    parameter grad_thresh = 2_500_000,
    parameter [31:0] dvsr = 4882 // sysclk /(pwm_frq*2^8)
)
(
    input logic clk,
    input logic rst,
    input logic [31:0] delay,
    output logic rainbow_out
);


typedef enum  { offset, rise, high, fall, low} state;
state currstate;

logic [R:0] duty;
logic [R:0] duty_reg;
logic gradient_pulse;
logic [31:0] counter;
logic [31:0] hold_counter;
logic [31:0] delay_counter;

localparam [31:0] grad_thresh_2x = 2*grad_thresh;

pwm_enhanced
#(
    .R(R)
)
pwm_enhanced_i
(
    .clk(clk),
    .rst(rst),
    .dvsr(dvsr),
    .duty(duty),
    .pwm_out(rainbow_out)
);


always_ff @( posedge clk, posedge rst) begin
    if (rst) begin
        duty_reg <= 0;
        currstate <= offset;
        counter <= 0;
        hold_counter <= 0;
        delay_counter <= 0;
    end
    else begin
        // offset
        if(currstate == offset) begin
            if (counter < grad_thresh) begin
                counter <= counter + 1;
                gradient_pulse <= 0;
            end
            else begin
                counter <= 0;
                gradient_pulse <= 1;
            end

            if (gradient_pulse == 1) begin
                hold_counter <= hold_counter + 1;
            end

            if (hold_counter == 256) begin
                hold_counter <= 0;
                delay_counter <= delay_counter + 1;
            end

            if (delay_counter == delay) begin
                currstate <= rise;
                delay_counter <= 0;
                hold_counter <= 0;
                counter <= 0;
            end
        end
        // Rise
        else if (currstate == rise) begin
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
                currstate <= high;
                counter <= 0;
            end
        end
        // High
        else if (currstate == high) begin
            if (counter < grad_thresh_2x) begin
                counter <= counter + 1;
                gradient_pulse <= 0;
            end
            else begin
                counter <= 0;
                gradient_pulse <= 1;
            end

            if (gradient_pulse == 1) begin
                hold_counter <= hold_counter + 1;
            end

            if (hold_counter == 256) begin
                currstate <= fall;
                hold_counter <= 0;
                counter <= 0;
            end
        end
        // Fall
        else if (currstate == fall) begin
            if (counter < grad_thresh) begin
                counter <= counter + 1;
                gradient_pulse <= 0;
            end
            else begin
                counter <= 0;
                gradient_pulse <= 1;
            end

            if (gradient_pulse == 1) begin
                duty_reg <= duty_reg - 1;
            end

            if (duty_reg == 0) begin
                currstate <= low;
                counter <= 0;
            end
        end
        // Low
        else if (currstate == low) begin
            if (counter < grad_thresh_2x) begin
                counter <= counter + 1;
                gradient_pulse <= 0;
            end
            else begin
                counter <= 0;
                gradient_pulse <= 1;
            end

            if (gradient_pulse == 1) begin
                hold_counter <= hold_counter + 1;
            end

            if (hold_counter == 256) begin
                currstate <= rise;
                hold_counter <= 0;
                counter <= 0;
            end
        end
        else begin
            currstate <= offset; 
        end
    end
end

assign duty = duty_reg;

endmodule