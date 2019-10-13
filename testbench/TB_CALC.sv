/* ============================================================================
 *  Title       : Signed add/sub package sample testbench
 *
 *  File Name	: TB_CALC.sv
 *  Project     :
 *  Block       :
 *  Tree        :
 *  Designer    : toms74209200 <https://github.com/toms74209200>
 *  Created     : 2019/10/13
 *  Copyright   : 2019 toms74209200
 *  License     : MIT License.
 *                http://opensource.org/licenses/mit-license.php
 * ============================================================================*/
`timescale 1ns/10ps

module TB_CALC ;

// System
logic           CLK;            //(p) Clock
logic           RESET_n;        //(n) Reset

// Control
logic           MODE;           //(p) Mode select(H:add, L:sub)
logic           SINK_VALID;     //(p) Data valid
logic [15:0]    SINK_DATAA;     //(p) Data A
logic [15:0]    SINK_DATAB;     //(p) Data B
logic           SOURCE_VALID;   //(p) Data valid
logic [15:0]    SOURCE_DATA;    //(p) Data

// Parameter
parameter ClkCyc = 20;

// Internal signal
logic [15:0]    reg_i;
logic [15:0]    reg_ii;

// Test module
CALC U_CALC (
    CLK,
    RESET_n,
    MODE,
    SINK_VALID,
    SINK_DATAA,
    SINK_DATAB,
    SOURCE_VALID,
    SOURCE_DATA
);

/* ============================================================================
 * Clock
 * ============================================================================*/
always begin
    CLK <= 1'b0;
    #(ClkCyc);
    CLK <= 1'b1;
    #(ClkCyc);
end

/* ============================================================================
 * Reset
 * ============================================================================*/
initial begin
    RESET_n <= 1'b0;
    repeat(2) @(posedge CLK);
    RESET_n <= 1'b1;
end

/* ============================================================================
 * Initialization
 * ============================================================================*/
initial begin
    MODE <= 1'b0;
    SINK_VALID <= 1'b0;
    SINK_DATAA <= 16'd0;
    SINK_DATAB <= 16'd0;

    reg_i <= 16'd0;
    reg_ii <= 16'd0;

    repeat(3) @(posedge CLK);

/* ============================================================================
 * Add
 * ============================================================================*/
    SINK_DATAA <= 16'd0;
    SINK_DATAB <= 16'd0;
    MODE <= 1'b1;
    @(posedge CLK);
    SINK_VALID <= 1'b1;
    @(posedge CLK);
    SINK_VALID <= 1'b0;

    @(posedge CLK);
    $display("Zero add:", SOURCE_DATA);

    @(posedge CLK);
    SINK_DATAA <= 16'd1;

// Fibonacci 
    for (int i=0;i<=16;i++) begin
        @(posedge CLK);
        SINK_VALID <= 1'b1;
        @(posedge CLK);
        SINK_VALID <= 1'b0;
        @(posedge CLK);
        reg_ii <= reg_i;
        reg_i <= SOURCE_DATA;
        SINK_DATAA <= reg_i;
        SINK_DATAB <= reg_ii;
        @(posedge CLK);
        $display("Fibonacci:", SOURCE_DATA);
    end

// a - b
    SINK_DATAA <= 16'd1;
    SINK_DATAB <= 16'h8002;
    @(posedge CLK);
    SINK_VALID <= 1'b1;
    @(posedge CLK);
    SINK_VALID <= 1'b0;
    @(posedge CLK);
    $display("a-b:", SOURCE_DATA);

// (-a) + b
    SINK_DATAA <= 16'h8002;
    SINK_DATAB <= 16'd1;
    @(posedge CLK);
    SINK_VALID <= 1'b1;
    @(posedge CLK);
    SINK_VALID <= 1'b0;
    @(posedge CLK);
    $display("b-a:", SOURCE_DATA);

// (-a) + (-b)
    SINK_DATAA <= 16'h8002;
    SINK_DATAB <= 16'h8002;
    @(posedge CLK);
    SINK_VALID <= 1'b1;
    @(posedge CLK);
    SINK_VALID <= 1'b0;
    @(posedge CLK);
    $display("b-a:", SOURCE_DATA);

// Overflow
    SINK_DATAA <= 16'h3FFF;
    SINK_DATAB <= 16'h3FFF;
    @(posedge CLK);
    SINK_VALID <= 1'b1;
    @(posedge CLK);
    SINK_VALID <= 1'b0;
    @(posedge CLK);
    $display("Overflow:", SOURCE_DATA);

/* ============================================================================
 * Sub
 * ============================================================================*/
    SINK_DATAA <= 16'd0;
    SINK_DATAB <= 16'd0;
    MODE <= 1'b0;
    @(posedge CLK);
    SINK_VALID <= 1'b1;
    @(posedge CLK);
    SINK_VALID <= 1'b0;

    @(posedge CLK);
    $display("Zero sub:", SOURCE_DATA);

// a - b
    SINK_DATAA <= 16'd5;
    SINK_DATAB <= 16'd2;
    @(posedge CLK);
    SINK_VALID <= 1'b1;
    @(posedge CLK);
    SINK_VALID <= 1'b0;
    @(posedge CLK);
    $display("a-b:", SOURCE_DATA);

// (-a) - b
    SINK_DATAA <= 16'h8002;
    SINK_DATAB <= 16'd1;
    @(posedge CLK);
    SINK_VALID <= 1'b1;
    @(posedge CLK);
    SINK_VALID <= 1'b0;
    @(posedge CLK);
    $display("b-a:", SOURCE_DATA);

// (-a) - (-b)
    SINK_DATAA <= 16'h8002;
    SINK_DATAB <= 16'h8005;
    @(posedge CLK);
    SINK_VALID <= 1'b1;
    @(posedge CLK);
    SINK_VALID <= 1'b0;
    @(posedge CLK);
    $display("b-a:", SOURCE_DATA);

// a - b
    SINK_DATAA <= 16'd1;
    SINK_DATAB <= 16'h8002;
    @(posedge CLK);
    SINK_VALID <= 1'b1;
    @(posedge CLK);
    SINK_VALID <= 1'b0;
    @(posedge CLK);
    $display("a-b:", SOURCE_DATA);

    $finish;
end

endmodule   //TB_CALC