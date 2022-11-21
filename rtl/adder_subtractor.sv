module adder_subtractor 
    #( parameter SIZE = 4
    ) 
    (
        input   logic                       mode_i,
        input   logic signed [SIZE-1:0]     a_i, 
        input   logic signed [SIZE-1:0]     b_i, 
        output  logic signed [SIZE:0]       c_o
    );

    assign c_o = (mode_i == 1) ? ( a_i + b_i ) : (a_i - b_i);

endmodule