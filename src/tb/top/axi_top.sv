//`include "axi_design.sv"
`include "uvm_macros.svh"
//`include "axi_package.sv"
//`include "axi_assertion.sv"
module axi_top;
  import uvm_pkg::*;
  import axi_pkg::*;

  bit ACLK;
  bit ARESETn;

  initial begin
    ACLK = 1'b0;
    forever begin
      #(`low)  ACLK = 1'b1;
      #(`high) ACLK = 1'b0;
    end
  end

  task apply_reset;
    ARESETn = 1'b0;
    repeat(2) @(posedge ACLK);
    ARESETn = 1'b1;
    `uvm_info("TESTBENCH", "Reset released", UVM_LOW)
  endtask

  initial begin
    apply_reset;
  end

  intf axi_inf(ACLK, ARESETn);

  axi4_lite_slave #(
    .DATA_WIDTH (`DATA_WIDTH),
    .ADDR_WIDTH (`ADDR_WIDTH),
    .MEM_DEPTH  (`MEM_DEPTH)
  ) dut (
    .ACLK    (ACLK),
    .ARESETn (ARESETn),

    // Write Address Channel
    .AWADDR  (axi_inf.AWADDR),
    .AWPROT  (axi_inf.AWPROT),
    .AWVALID (axi_inf.AWVALID),
    .AWREADY (axi_inf.AWREADY),

    // Write Data Channel
    .WDATA   (axi_inf.WDATA),
    .WSTRB   (axi_inf.WSTRB),
    .WVALID  (axi_inf.WVALID),
    .WREADY  (axi_inf.WREADY),

    // Write Response Channel
    .BRESP   (axi_inf.BRESP),
    .BVALID  (axi_inf.BVALID),
    .BREADY  (axi_inf.BREADY),

    // Read Address Channel
    .ARADDR  (axi_inf.ARADDR),
    .ARPROT  (axi_inf.ARPROT),
    .ARVALID (axi_inf.ARVALID),
    .ARREADY (axi_inf.ARREADY),

    // Read Data Channel
    .RDATA   (axi_inf.RDATA),
    .RRESP   (axi_inf.RRESP),
    .RVALID  (axi_inf.RVALID),
    .RREADY  (axi_inf.RREADY)
  );

  //axi_assertions axi_assert(axi_inf);

  initial begin
    uvm_config_db #(virtual intf)::set(null, "*", "axi_inf", axi_inf);
  end

  initial begin
    run_test("axi_regression_test");
  end

  initial begin
    #100_000;
    `uvm_fatal("TIMEOUT", "Simulation timed out at 100us!")
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end

endmodule

