module datapath(pixel_value, error, load_R1, load_R2, load_R3, wrt_ptr, opcode, load_ptr, mux_1_sel, mux_2_sel, mux_3_sel, rd_ptr, inc_wrt_ptr, clk, rst, edge_case_first_row, edge_case_first_col);
    parameter word_size = 8;
    //input control signals
    input load_R1, load_R2, load_R3, load_ptr, inc_wrt_ptr, mux_1_sel;
    input [1:0] mux_3_sel, mux_2_sel;
    input [2:0] opcode;
    input clk, rst;
    output [word_size:0] error;
    output signed [18:0] rd_ptr;
    input [word_size-1:0] pixel_value;
    output [17:0] wrt_ptr;
    wire [word_size:0]  mux_1_out, R1_out, R2_out, R3_out;
    wire [18:0] alu_out;
    
    assign error = alu_out[8:0];
    wire [8:0] signed_pixel_value = {1'b0,pixel_value};

    wire [18:0] signext_instance_2_out;

    wire [18:0] mux_2_out, mux_3_out;
    
    wire [18:0] const_512 = 19'd512;
    wire [18:0] const_511 = 19'd511;


    output edge_case_first_row, edge_case_first_col;
    assign edge_case_first_row = (rd_ptr < 19'sd512);
    assign edge_case_first_col = (rd_ptr % 19'd512 == 0);
    
    wire [18:0] R3_signextended, R1_signextended;
    signext signext_R1 (
        .in(R1_out),
        .out(R1_signextended)
    );

    signext signext_R3 (
        .in(R3_out),
        .out(R3_signextended)
    );



    Register_Unit R1(.data_out(R1_out), .data_in(signed_pixel_value), .load(load_R1), .clk(clk), .rst(rst));
    Register_Unit R2(.data_out(R2_out), .data_in(signed_pixel_value), .load(load_R2), .clk(clk), .rst(rst));
    Register_Unit R3(.data_out(R3_out), .data_in(alu_out[8:0]), .load(load_R3), .clk(clk), .rst(rst));


    signext signext_instance_2 (
        .in(R2_out),
        .out(signext_instance_2_out)
    );

   

    multiplexer_3_channel mux_3(.data_1(signext_instance_2_out), .data_2(const_512), .data_3(const_511), .sel(mux_3_sel), .data_out(mux_3_out));

    multiplexer_3_channel mux_2 (
        .data_1(R1_signextended),
        .data_2(R3_signextended),
        .data_3(rd_ptr),
        .sel(mux_2_sel),
        .data_out(mux_2_out)
    );
    alu alu(.data_in_1(mux_2_out), .data_in_2(mux_3_out), .opcode(opcode), .data_out(alu_out));

    addr_unit rd_ptr_reg(.data_out(rd_ptr), .data_in(alu_out), .load(load_ptr), .clk(clk), .rst(rst));
endmodule