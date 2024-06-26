module TimeHandler #(parameter n = 700) (input CLK, Start, output reg [4:0]hour);
    reg [31:0] counter = 0;
    always @(posedge Start or posedge CLK) begin
        if (Start) begin
            hour = 32'd0;
            counter = 0;
        end else begin
            counter = counter + 1;
            if (counter % n == 0) begin
                counter = 0;
                hour = hour + 1;
                if (hour == 32'd24) begin
                    hour = 32'd0;
                end
            end
        end
    end
endmodule
