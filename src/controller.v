module controller(load_R1, load_R2, load_R3, load_ptr, mux_1_sel, mux_2_sel, mux_3_sel, enable, opcode, clk, rst, edge_case_first_row, edge_case_first_col);

    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;
    parameter S5 = 3'b101;
    parameter S6 = 3'b110;

    parameter NOP = 3'b000;
    parameter D1 = 3'b001;
    parameter D2 = 3'b010;
    parameter ADD = 3'b011;
    parameter AVG = 3'b100;
    parameter SUB1 = 3'b101;
    parameter SUB2 = 3'b110;



    parameter state_size = 3;

    reg [2:0] state, next_state;

    //output control signals
    output reg load_R1, load_R2, load_R3, load_ptr, mux_1_sel, enable;
    output reg [1:0] mux_3_sel, mux_2_sel;
    output reg[2:0] opcode;
    input clk, rst;
 
    input edge_case_first_row, edge_case_first_col;




    //state change
    always @(posedge clk or posedge rst) begin
        if (rst) state <= S0;
        else state <= next_state;
    end
    
    always @(*) begin//??
        load_R1 = 0; load_R2 = 0; load_R3 = 0; load_ptr = 0; mux_1_sel = 0; enable = 0;
        next_state = state;

        

        case (state)
            S0: // load r1
            begin
                
                load_R1 = 1;
                next_state = S1;
                
                




            end

            S1:
            begin
                
                
                load_ptr = 1;
                opcode = SUB1; // subtract 511
                mux_2_sel = 2'b10;
                mux_3_sel = 2'b10;
                next_state = S2;
                
                
            end

            S2:
            begin
                
                load_R2 = 1; 
                
                next_state = S3;
                
                

            end
            
            S3:
            begin

                load_ptr = 1;
                opcode = ADD; // add 512
                //mux_1_sel = 1;
                mux_3_sel = 2'b01;
                mux_2_sel = 2'b10;
                next_state = S4;
                
                
            end

            S4:
            begin
                
                load_R3 = 1;
                case({edge_case_first_row, edge_case_first_col})
                    2'b00: opcode = AVG;
                    2'b01: opcode = D2;
                    2'b10: opcode = D1;
                    2'b11: opcode = NOP;
                endcase              
                mux_2_sel = 2'b00;
                mux_3_sel = 2'b00;
                
                next_state = S5;
                
            end

            S5:
            begin
                
                load_R2 = 1;
                
                next_state = S6;
            end

            S6:
            begin
                
                enable = 1;
                opcode = SUB2; // subtract
                mux_2_sel = 2'b01;
                mux_3_sel = 2'b00;
                next_state = S0;
            end

            default:
            begin
                next_state = S0;
            end
        endcase
    end
endmodule