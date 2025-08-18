module huffman_encoder(clk, rst, code, len, byte_out, write, enable);
    parameter code_size = 18;
    parameter word_size = 8;
    parameter len_size = 5;


    input clk, rst, enable;
    input [code_size-1:0] code;
    input [len_size-1:0] len;
    output reg [word_size-1:0] byte_out;
    output reg write;

    reg [5:0] count;
    reg [2*code_size - 1 : 0] buffer;


   

    wire [35:0] padded_code;
    assign padded_code = {{18{1'b0}}, code};


    

        
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            buffer <= 0;
            count <= 0;
        end
        if (enable) 
        begin
    
            buffer <= (buffer << len) | padded_code;

            count <= count + len;
             

        end

        if (count >= 8) begin
            write <= 1;
        
            byte_out <= (buffer >> (count - 8));
            count <= count - 8;
        end
        else write <= 0;


    end  
endmodule

module LUT(error, code, len);
    input signed [8:0] error;
    output [17:0] code;
    output [4:0] len;

    wire [8:0] error_index;
    assign error_index = error + 9'd256;


    reg [17:0] code_rom [0:511];
    reg [4:0] len_rom  [0:511];

    initial $readmemb("huff_code.mem", code_rom);
    initial $readmemb("huff_len.mem",  len_rom);

    assign code = code_rom[error_index];
    assign len = len_rom[error_index];
endmodule
