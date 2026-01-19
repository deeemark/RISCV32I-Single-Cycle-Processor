`timescale 1ns/1ps

module tb_top;

  logic clk = 0;
  logic reset = 1;

  // DUT
  top dut (
    .clk(clk),
    .reset(reset)
  );

  // 100 MHz clock (10 ns period)
  always #5 clk = ~clk;

  // Reset sequence
  initial begin
    reset = 1'b1;
    repeat (5) @(posedge clk);
    reset = 1'b0;
    $display("Reset deasserted at t=%0t", $time);
  end

  int cycle = 0;

  // Monitor + stop conditions
  always @(posedge clk) begin
    cycle++;

    if (!reset) begin
      $display(
        "C%0d PC=%h  x1=%h x2=%h x3=%h x4=%h x5=%h  x13(lw)=%h  x19(lh)=%h x20(lhu)=%h x21(lb)=%h x22(lbu)=%h  x25(lbFF)=%h x26(lbuFF)=%h x27(lh8001)=%h x28(lhu8001)=%h  misaligned=%b",
        cycle,
        dut.pc,
        dut.u_register_file.regs[1],
        dut.u_register_file.regs[2],
        dut.u_register_file.regs[3],
        dut.u_register_file.regs[4],
        dut.u_register_file.regs[5],
        dut.u_register_file.regs[13],
        dut.u_register_file.regs[19],
        dut.u_register_file.regs[20],
        dut.u_register_file.regs[21],
        dut.u_register_file.regs[22],
        dut.u_register_file.regs[25],
        dut.u_register_file.regs[26],
        dut.u_register_file.regs[27],
        dut.u_register_file.regs[28],
        dut.misaligned
      );

      // Stop when program reaches the end-loop PC
      if (dut.pc == 32'h0000_0094) begin
        $display("Reached end loop at PC=%h (cycle %0d)", dut.pc, cycle);
        dump_final_state();
        $finish;
      end
    end

    // Safety stop
    if (cycle > 300) begin
      $display("Stopping after %0d cycles (safety stop)", cycle);
      dump_final_state();
      $finish;
    end
  end

  task dump_final_state;
    integer r;
    integer w;
    begin
      $display("---- FINAL REGISTERS ----");
      for (r = 0; r < 32; r++) begin
        if (r == 0) $display("x%0d = %h", r, 32'h0);
        else        $display("x%0d = %h", r, dut.u_register_file.regs[r]);
      end

      $display("---- FINAL DMEM (first 16 words) ----");
      for (w = 0; w < 16; w++) begin
        $display("dmem[%0d] = %h", w, dut.u_data_memory.dmem[w]);
      end
    end
  endtask

endmodule
