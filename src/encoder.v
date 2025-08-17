module encoder(clk, rst);
    parameter word_size = 8;
    input clk, rst;

    wire [word_size-1:0] pixel_value;
    wire [8:0] error;
    
    //control signals
    wire load_R1, load_R2, load_R3;
    wire write, load_ptr;
    wire mux_1_sel;
    wire [1:0] mux_2_sel, mux_3_sel;
    wire [2:0] opcode;

    wire [17:0] wrt_ptr;
    wire inc_wrt_ptr;
    wire [18:0] rd_ptr;



        wire [17:0] code;
        wire [4:0] len;
    wire [7:0] byte_out;
         wire enable;
         wire write_to_storage;

    wire edge_case_first_col;
    wire edge_case_first_row;

  

    
    image_mem image_mem(
        .data_out(pixel_value),
        .address(rd_ptr)
    );

    datapath M0_processor(
        .pixel_value(pixel_value),
        .error(error),
        .load_R1(load_R1),
        .load_R2(load_R2),
        .load_R3(load_R3),
        .wrt_ptr(wrt_ptr),
        .opcode(opcode),
        .load_ptr(load_ptr),
        .mux_1_sel(mux_1_sel),
        .mux_2_sel(mux_2_sel),
        .mux_3_sel(mux_3_sel),
        .rd_ptr(rd_ptr),
        .inc_wrt_ptr(inc_wrt_ptr),
        .clk(clk),
        .rst(rst),
        .edge_case_first_col(edge_case_first_col),
        .edge_case_first_row(edge_case_first_row)
    );

    controller M1_controller(
        .load_R1(load_R1),
        .load_R2(load_R2),
        .load_R3(load_R3),
        .load_ptr(load_ptr),
        .mux_1_sel(mux_1_sel),
        .mux_2_sel(mux_2_sel),
        .mux_3_sel(mux_3_sel),
        .enable(enable),
        .opcode(opcode),
        .clk(clk),
        .rst(rst),
        .edge_case_first_col(edge_case_first_col),
        .edge_case_first_row(edge_case_first_row)
    );

    LUT LUT (
        .error(error),
        .code(code),
        .len(len)
    );

    huffman_encoder huffman_encoder_instance (
        .clk(clk),
        .rst(rst),
        .code(code),
        .len(len),
        .byte_out(byte_out),
        .write(write_to_storage),
        .enable(enable)
    );


   

    coded_storage coded_storage(
        .data_in(byte_out),
        .clk(clk),
        .rst(rst),
        .write(write_to_storage)
    );  
endmodule