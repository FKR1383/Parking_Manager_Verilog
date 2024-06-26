module Parking(input CLK, Start, car_entered, is_uni_car_entered, car_exited, is_uni_car_exited,
        output reg [9:0]uni_parked_car, output reg [9:0]parked_car, output reg[9:0]uni_vacated_space, output reg[9:0]vacated_space, 
        output reg uni_is_vacated_space, is_vacated_space, overflow_uni, overflow, rejected_uni, rejected, output wire [4:0] hour);
        //reg [4:0]hour;
        reg [9:0]uni_space;
        reg [9:0]space;
        reg [4:0]last_hour = 0;
        TimeHandler #(700) th(CLK, Start, hour);
        always @(Start or CLK or hour) begin
			overflow = 0;
            overflow_uni = 0;
            if (hour == 8 && last_hour < hour) begin
                last_hour = hour;
                space = 10'd200;
                uni_space = 10'd500;
                if (space < parked_car) begin
                    overflow = 1;
                    parked_car = space;
                    vacated_space = 0;
                    uni_vacated_space = uni_space - uni_parked_car;
                end else begin
                    vacated_space = space - parked_car;
                    uni_vacated_space = uni_space - uni_parked_car;
                end
            end else if (hour >= 13 && hour < 16 && last_hour < hour) begin
                last_hour = hour;
                space = space + 50;
                uni_space = uni_space - 50;
                if (uni_space < uni_parked_car) begin
                    overflow_uni = 1;
                    uni_parked_car = uni_space;
                    vacated_space = space - parked_car;
                    uni_vacated_space = 0;
                end else begin
                    vacated_space = space - parked_car;
                    uni_vacated_space = uni_space - uni_parked_car;
                end
            end else if (hour == 16 && last_hour < hour) begin
                last_hour = hour;
                space = 500;
                uni_space = 200;
                if (uni_space < uni_parked_car) begin
                    overflow_uni = 1;
                    uni_parked_car = uni_space;
                    vacated_space = space - parked_car;
                    uni_vacated_space = 0;
                end else begin
                    vacated_space = space - parked_car;
                    uni_vacated_space = uni_space - uni_parked_car;
                end
            end
            if (Start) begin
                uni_parked_car = 0;
                parked_car = 0;
                uni_vacated_space = 10'd200;
                vacated_space = 10'd500;
                space = 10'd500;
                uni_space = 10'd200;
                uni_is_vacated_space = 1;
                is_vacated_space = 1;
                rejected = 0;
                overflow = 0;
                rejected_uni = 0;
                overflow_uni = 0;
            end else if (car_entered == 1) begin
                if (is_uni_car_entered) begin
                    if (uni_vacated_space == 0) begin
                        rejected_uni = 1;
                    end else begin
                        rejected_uni = 0;
                        uni_vacated_space = uni_vacated_space - 1;
                        uni_parked_car = uni_parked_car + 1;
                    end
                end else begin
                    if (vacated_space == 0) begin
                        rejected = 1;
                    end else begin
                        rejected = 0;
                        vacated_space = vacated_space - 1;
                        parked_car = parked_car + 1;
                    end
                end
            end else if (car_exited == 1) begin
                if (is_uni_car_exited) begin
                    if (uni_parked_car == 0) begin
                        rejected_uni = 1;
                    end else begin
                        rejected_uni = 0;
                        uni_vacated_space = uni_vacated_space + 1;
                        uni_parked_car = uni_parked_car - 1;
                    end
                end else begin
                    if (parked_car == 0) begin
                        rejected = 1;
                    end else begin
                        rejected = 0;
                        vacated_space = vacated_space + 1;
                        parked_car = parked_car - 1;
                    end
                end
            end
        end
endmodule
