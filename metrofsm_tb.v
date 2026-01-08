`timescale 1ns/1ps
`include "metrofsm.v"

module metrofsm_tb;

  reg clk;
  reg rst;
  reg [3:0] access_code;
  reg validate_code;

  wire open_access_door;
  wire [1:0] state_out;

  // DUT
  metrofsm dut (
    .clk(clk),
    .rst(rst),
    .access_code(access_code),
    .validate_code(validate_code),
    .open_access_door(open_access_door),
    .state_out(state_out)
  );

  // -------------------------
  // Clock: 10 ns period
  // -------------------------
  always #5 clk = ~clk;

  // -------------------------
  // Initial values
  // -------------------------
  initial begin
    clk = 0;
    rst = 0;
    access_code = 4'd0;
    validate_code = 1'b0;
  end

  // -------------------------
  // Reset
  // -------------------------
  initial begin
    #12;
    rst = 1'b1;
  end

  // -------------------------
  // Stimulus
  // -------------------------
  initial begin
    // Wait for reset release
    @(posedge rst);

    // ---------- VALID ACCESS ----------
    @(negedge clk);
    access_code   = 4'd9;   // valid code (4–11)
    validate_code = 1'b1;

    @(negedge clk);
    validate_code = 1'b0;   // IMPORTANT: pulse ends

    // Wait while ACCESS_GRANTED runs
    repeat (20) @(posedge clk);

    // ---------- INVALID ACCESS ----------
    @(negedge clk);
    access_code   = 4'd2;   // invalid code
    validate_code = 1'b1;

    @(negedge clk);
    validate_code = 1'b0;

    repeat (10) @(posedge clk);

    $finish;
  end

  // -------------------------
  // Dump
  // -------------------------
  initial begin
    $dumpfile("metrofsm.vcd");
    $dumpvars(0, metrofsm_tb);
  end

endmodule
