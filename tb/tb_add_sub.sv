`timescale 1ps/1ps
`define CLK_PERIOD  10.0ns

module tb_add_sub;
    
    // declare tb variables
    localparam TB_SIZE = 8;
    localparam NUMBER_VECT = 100;

    logic                           tb_mode_i;
    logic  signed [TB_SIZE-1:0]     tb_a_i;
    logic  signed [TB_SIZE-1:0]     tb_b_i; 
    logic  signed [TB_SIZE:0]       tb_c_o;
    logic  signed [TB_SIZE:0]       result;
    logic [31:0]                    error_counter;

    // instantiate the design and connect to tb variables
    adder_subtractor
    #(
        .SIZE   ( TB_SIZE )
    )
    add_sub_io
    (
        .mode_i ( tb_mode_i ),
        .a_i    ( tb_a_i    ),
        .b_i    ( tb_b_i    ),
        .c_o    ( tb_c_o    )
    );

    // tasks

    task INIT_SIM;
        begin
            error_counter = '0;

            tb_mode_i   = '0;
            tb_a_i      = '0;
            tb_b_i      = '0;
        end
    endtask 

    task OPERATION;
        begin
            for (int i = 0; i < NUMBER_VECT; i++) begin

                if (i%10 == 5) begin
                    tb_mode_i = ~tb_mode_i;
                end
                
                if (tb_mode_i == 1) begin
                    tb_a_i = i;
                    tb_b_i = i - 5;
                    result = tb_a_i + tb_b_i;
                end
                else begin

                    tb_a_i = 5;
                    tb_b_i = i ;
                    result = tb_a_i - tb_b_i;
                end
                

                #(`CLK_PERIOD);
                //#10;

                if (result != tb_c_o) begin
                    error_counter = error_counter + 1;
                end
            end
        end
    endtask 

    task DISPLAY_TEST_RESULT;
        begin
            if (error_counter == 0) begin
                $display("*** SIMULATION PASSED ***");
            end
            else begin
                $display("*** SIMULATION FAILED ***");
            end

        end
    endtask 


    
    // main
    initial 
    begin : main
        
        $display("*** Testbench started");

        INIT_SIM();
        OPERATION();
        DISPLAY_TEST_RESULT();

        $display("*** Simulation done");
        $finish; 
        //$stop; 
    end


endmodule