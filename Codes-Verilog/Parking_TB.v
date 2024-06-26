module Parking_TB;
    reg CLK, Start, car_entered, is_uni_car_entered, car_exited, is_uni_car_exited;
    wire [9:0]uni_parked_car, parked_car, uni_vacated_space, vacated_space;
    wire uni_is_vacated_space, is_vacated_space, overflow_uni, overflow, rejected_uni, rejected;
    wire [4:0] hour;
    integer i;

    Parking p(CLK, Start, car_entered, is_uni_car_entered, car_exited, is_uni_car_exited,
        uni_parked_car, parked_car, uni_vacated_space, vacated_space, 
        uni_is_vacated_space, is_vacated_space, overflow_uni, overflow, rejected_uni, rejected, hour
    );

    initial begin
        CLK = 0;
        Start = 1;
        #1
        Start = 0;
        for (i = 0; i < 100; i = i + 1) begin
            car_entered = 1;
            is_uni_car_entered = 1;
            #2;  
        end
        for (i = 0; i < 500; i = i + 1) begin
            car_entered = 1;
            is_uni_car_entered = 0;
            #2;
        end
        car_entered = 0;
        // uni_parked_car = 100, parked_car = 500
        #(1400 * 8); // 8 hours later -- uni_parked_car = 100, parked_car = 200 (overflow = 1)

        
        
        for (i = 0; i < 300; i = i + 1) begin
            car_entered = 1;
            is_uni_car_entered = 1;
            #2;
        end
        car_entered = 0;
        for (i = 0; i < 100; i = i + 1) begin
            car_exited = 1;
            is_uni_car_exited = 0;
            #2;
        end
        car_exited = 0;
        // uni_parked_car = 400, parked_car = 100
        #(1400 * 5); // 5 hours later
        #(1400 * 3); // 3 hours later -- uni_parked_car = 200, parked_car = 100

        
        
        for (i = 0; i < 200; i = i + 1) begin
            car_exited = 1;
            is_uni_car_exited = 1;
            #2;
        end
        for (i = 0; i < 200; i = i + 1) begin
            car_exited = 1;
            is_uni_car_exited = 0;
            #2;
        end
        


        car_exited = 1;
        is_uni_car_exited = 0;
        #2;
        car_exited = 1;
        is_uni_car_exited = 1;
        #2;
        car_exited = 0;
        $stop();

    end
    always begin
        #1 CLK = ~CLK;
    end
endmodule
