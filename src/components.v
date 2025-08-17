module Register_Unit(data_out, data_in, load, clk, rst);
    parameter word_size = 8;
    input clk, rst, load;
    input [word_size:0] data_in; // not signed
    output reg [word_size:0] data_out; // not signed
    always @(posedge clk or posedge rst)
        begin
            if (rst) data_out <= 0;
            else if (load)data_out <= data_in;
        end
endmodule

module addr_unit(data_out, data_in, load, clk, rst);
    parameter addr_size = 19;
    input clk, rst, load;
    input [addr_size-1:0] data_in; 
    output reg [addr_size-1:0] data_out;
    always @(posedge clk or posedge rst)
        begin
            if (rst) data_out <= 19'b1111111111111111111;
            else if (load)data_out <= data_in;
        end
endmodule
        
module alu(data_in_1, data_in_2, opcode, data_out);
    parameter word_size = 8;

    parameter NOP = 3'b000;
    parameter D1 = 3'b001;
    parameter D2 = 3'b010;
    parameter ADD = 3'b011;
    parameter AVG = 3'b100;
    parameter SUB1 = 3'b101;
    parameter SUB2 = 3'b110;

    input [2:0] opcode;
    input signed [18:0] data_in_1, data_in_2;
    output data_out;
    reg signed [18:0] data_out;
 

   
    always @(*)
        case(opcode)
            (NOP): begin
                data_out = 19'b0;
            end
            (D1): begin
                data_out = (data_in_1);
            end
            (D2): begin
                data_out = (data_in_2);
            end
            (ADD): begin
                data_out = (data_in_1 + data_in_2);
            end
            (AVG): begin
                data_out = ((data_in_1 + data_in_2)/2);
            end
            (SUB1): begin
                data_out = (data_in_1 - data_in_2);
            end
            (SUB2): begin
                data_out = (data_in_2 - data_in_1);
            end

            
        endcase            
endmodule

module signext(in, out);
    input [8:0] in;
    output [18:0] out;
    assign out = {{10{in[8]}}, in};
endmodule

module multiplexer_2_channel(data_1, data_2, sel, data_out);
    parameter word_size = 19;
    input [word_size-1:0] data_1, data_2;
    input sel;
    output [word_size-1:0] data_out;

    assign data_out = sel ? data_2 : data_1;
endmodule

module multiplexer_3_channel(data_1, data_2, data_3, sel, data_out);
    parameter word_size = 19;
    input [word_size-1:0] data_1, data_2, data_3;
    input [1:0] sel;
    output [word_size-1:0] data_out;

    assign data_out = (sel == 0) ? data_1 :
                      (sel == 1) ? data_2 :
                      (sel == 2) ? data_3 :
                      'bx;
endmodule

module image_mem(data_out, address);
    parameter word_size = 8;
    parameter memory_size = 2**18;
    input [18:0] address;
    wire [17:0] unsigned_address = address[17:0];
    output [word_size-1:0] data_out;

    initial
        begin
            $readmemh("lena.mem",RAM);
        end
    
    reg [word_size-1:0] RAM[memory_size-1:0];
    assign data_out = address[18] ? 8'b0 : RAM[unsigned_address];
endmodule

module memory_unit(data_out, data_in, address, clk, write);

    parameter word_size = 8;
    parameter memory_size = 2**18;
    input [word_size:0] data_in;
    input [17:0] address;
    output [word_size:0] data_out;
    input clk, write;
    reg [word_size:0] mem[memory_size-1:0];
    always @ (posedge clk)
        if (write) mem[address] <= data_in;
    assign data_out = mem[address];
endmodule

module coded_storage(data_out, data_in, clk, rst, write);

    parameter word_size = 8;
    parameter memory_size = 2**18;
    input [word_size-1:0] data_in;
    output [word_size-1:0] data_out;
    input clk, write, rst;
    reg [word_size-1:0] mem[memory_size-1:0];
    reg [17:0] address;
    always @ (posedge clk, posedge rst)
        if (rst) address <= 0;
        else if (write) begin
           mem[address] <= data_in;
           address = address + 1;  
        end 
    assign data_out = mem[address];
endmodule